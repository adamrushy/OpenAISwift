import Foundation
#if canImport(FoundationNetworking) && canImport(FoundationXML)
import FoundationNetworking
import FoundationXML
#endif

public enum OpenAIError: Error {
    case genericError(error: Error)
    case decodingError(error: Error)
}

public class OpenAISwift {
    fileprivate(set) var token: String?
    
	var promopts = Prompts()
	
    public init(authToken: String) {
        self.token = authToken
    }
}

extension OpenAISwift {
	
	public func sendStreamCompletion(with prompt: String,
									 model: OpenAIModelType = .gpt3(.davinci),
									 maxTokens: Int = 16,
									 temperature: Double = 0.5) async throws -> AsyncThrowingStream<String, Error>{
		let endpoint = Endpoint.completions
		let body = await Command(prompt: self.promopts.generateChatGPTPrompt(from: prompt), model: model.modelName, maxTokens: maxTokens, temperature: temperature, stream: true)
		let request = prepareRequest(endpoint, body: body)
		
		let result = try await makeStreamRequest(input: prompt, request: request)
		return result
	}
	
    /// Send a Completion to the OpenAI API
    /// - Parameters:
    ///   - prompt: The Text Prompt
    ///   - model: The AI Model to Use. Set to `OpenAIModelType.gpt3(.davinci)` by default which is the most capable model
    ///   - maxTokens: The limit character for the returned response, defaults to 16 as per the API
    ///   - completionHandler: Returns an OpenAI Data Model
	public func sendCompletion(with prompt: String,
							   model: OpenAIModelType = .gpt3(.davinci),
							   maxTokens: Int = 16,
							   temperature: Double = 0.5,
							   completionHandler: @escaping (Result<OpenAI, OpenAIError>) -> Void) async {
        let endpoint = Endpoint.completions
		let body = await Command(prompt: self.promopts.generateChatGPTPrompt(from: prompt), model: model.modelName, maxTokens: maxTokens, temperature: temperature, stream: false)
        let request = prepareRequest(endpoint, body: body)
        
		makeRequest(request: request) { result in
            switch result {
            case .success(let success):
                do {
                    let res = try JSONDecoder().decode(OpenAI.self, from: success)
					Task {
						let responseText = res.choices.first?.text ?? ""
						await self.promopts.appendToHistoryList(userText: prompt, responseText: responseText)
					}
                    completionHandler(.success(res))
					
                } catch {
                    completionHandler(.failure(.decodingError(error: error)))
                }
            case .failure(let failure):
                completionHandler(.failure(.genericError(error: failure)))
            }
        }
    }
    
    /// Send a Edit request to the OpenAI API
    /// - Parameters:
    ///   - instruction: The Instruction For Example: "Fix the spelling mistake"
    ///   - model: The Model to use, the only support model is `text-davinci-edit-001`
    ///   - input: The Input For Example "My nam is Adam"
    ///   - completionHandler: Returns an OpenAI Data Model
    public func sendEdits(with instruction: String, model: OpenAIModelType = .feature(.davinci), input: String = "", completionHandler: @escaping (Result<OpenAI, OpenAIError>) -> Void) {
        let endpoint = Endpoint.edits
        let body = Instruction(instruction: instruction, model: model.modelName, input: input)
        let request = prepareRequest(endpoint, body: body)
        
        makeRequest(request: request) { result in
            switch result {
            case .success(let success):
                do {
                    let res = try JSONDecoder().decode(OpenAI.self, from: success)
                    completionHandler(.success(res))
                } catch {
                    completionHandler(.failure(.decodingError(error: error)))
                }
            case .failure(let failure):
                completionHandler(.failure(.genericError(error: failure)))
            }
        }
    }
    
    private func makeRequest(request: URLRequest, completionHandler: @escaping (Result<Data, Error>) -> Void) {
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
			
			guard let httpRes = response as? HTTPURLResponse else {
				completionHandler(.failure("Invalid response"))
				return
			}
			
			guard 200...299 ~= httpRes.statusCode else {
				completionHandler(.failure("Bad Response: \(httpRes.statusCode)"))
				return
			}
			
            if let error = error {
                completionHandler(.failure(error))
            } else if let data = data {
                completionHandler(.success(data))
            }
        }
        
        task.resume()
    }
    
	private func makeStreamRequest(input: String, request urlRequest: URLRequest) async throws -> AsyncThrowingStream<String, Error> {
		
		let (result, response) = try await URLSession.shared.bytes(for: urlRequest)
		
		guard let httpResponse = response as? HTTPURLResponse else {
			throw "Invalid response"
		}
		
		guard 200...299 ~= httpResponse.statusCode else {
			throw "Bad Response: \(httpResponse.statusCode)"
		}
		
		return AsyncThrowingStream<String, Error> { continuation in
			Task(priority: .userInitiated) {
				do {
					var responseText = ""
					for try await line in result.lines {
						if line.hasPrefix("data: "),
						   let data = line.dropFirst(6).data(using: .utf8),
						   let response = try? JSONDecoder().decode(OpenAI.self, from: data),
						   let text = response.choices.first?.text {
							responseText += text
							continuation.yield(text)
						}
					}
					await self.promopts.appendToHistoryList(userText: input, responseText: responseText)
					continuation.finish()
				} catch {
					continuation.finish(throwing: error)
				}
			}
		}
		
	}
	
    private func prepareRequest<BodyType: Encodable>(_ endpoint: Endpoint, body: BodyType) -> URLRequest {
        var urlComponents = URLComponents(url: URL(string: endpoint.baseURL())!, resolvingAgainstBaseURL: true)
        urlComponents?.path = endpoint.path
        var request = URLRequest(url: urlComponents!.url!)
        request.httpMethod = endpoint.method
        
        if let token = self.token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(body) {
            request.httpBody = encoded
        }
        
        return request
    }
}

extension OpenAISwift {
    /// Send a Completion to the OpenAI API
    /// - Parameters:
    ///   - prompt: The Text Prompt
    ///   - model: The AI Model to Use. Set to `OpenAIModelType.gpt3(.davinci)` by default which is the most capable model
    ///   - maxTokens: The limit character for the returned response, defaults to 16 as per the API
    /// - Returns: Returns an OpenAI Data Model
    @available(swift 5.5)
    @available(macOS 10.15, iOS 13, watchOS 6, tvOS 13, *)
    public func sendCompletion(with prompt: String, model: OpenAIModelType = .gpt3(.davinci), maxTokens: Int = 16) async throws -> OpenAI {
        return try await withCheckedThrowingContinuation { continuation in
			Task {
				await sendCompletion(with: prompt, model: model, maxTokens: maxTokens) { result in
					continuation.resume(with: result)
				}
			}
        }
    }
    
    /// Send a Edit request to the OpenAI API
    /// - Parameters:
    ///   - instruction: The Instruction For Example: "Fix the spelling mistake"
    ///   - model: The Model to use, the only support model is `text-davinci-edit-001`
    ///   - input: The Input For Example "My nam is Adam"
    ///   - completionHandler: Returns an OpenAI Data Model
    @available(swift 5.5)
    @available(macOS 10.15, iOS 13, watchOS 6, tvOS 13, *)
    public func sendEdits(with instruction: String, model: OpenAIModelType = .feature(.davinci), input: String = "", completionHandler: @escaping (Result<OpenAI, OpenAIError>) -> Void) async throws -> OpenAI {
        return try await withCheckedThrowingContinuation { continuation in
            sendEdits(with: instruction, model: model, input: input) { result in
                continuation.resume(with: result)
            }
        }
    }
}

extension String: CustomNSError {
	
	public var errorUserInfo: [String : Any] {
		[
			NSLocalizedDescriptionKey: self
		]
	}
}
