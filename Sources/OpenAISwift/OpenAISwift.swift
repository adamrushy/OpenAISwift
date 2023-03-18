import Foundation
#if canImport(FoundationNetworking) && canImport(FoundationXML)
import FoundationNetworking
import FoundationXML
#endif

public enum OpenAIError: Error {
    case internalError(error: InternalError)
    case genericError(error: Error)
    case decodingError(error: Error)
}

public struct RequestError: LocalizedError {
    public var errorDescription: String {
        "Error creating the OpenAI API URL."
    }
}

public struct InternalError: LocalizedError {
    public let message: String
    public let type: String
    public let param: String?
    public let code: String?
    
    public var errorDescription: String {
        message
    }
}

struct ResponseError: Decodable {
    public let error: InternalError
}

extension InternalError: Decodable {}

public class OpenAISwift {
    private let urlSession: URLSession
    private let token: String
    
    public init(urlSession: URLSession = .shared, authToken: String) {
        self.urlSession = urlSession
        self.token = authToken
    }
}

extension OpenAISwift {
    /// Send a Completion to the OpenAI API
    /// - Parameters:
    ///   - prompt: The Text Prompt
    ///   - model: The AI Model to Use. Set to `OpenAIModelType.gpt3(.davinci)` by default which is the most capable model
    ///   - maxTokens: The limit character for the returned response, defaults to 16 as per the API
    ///   - completionHandler: Returns an OpenAI Data Model
    public func sendCompletion(with prompt: String, model: OpenAIModelType = .gpt3(.davinci), maxTokens: Int = 16, temperature: Double = 1, completionHandler: @escaping (Result<OpenAI<TextResult>, OpenAIError>) -> Void) {
        let endpoint = Endpoint.completions
        let body = Command(prompt: prompt, model: model.modelName, maxTokens: maxTokens, temperature: temperature)
        makeRequest(endpoint: endpoint, body: body, completionHandler: completionHandler)
    }
    
    /// Send a Edit request to the OpenAI API
    /// - Parameters:
    ///   - instruction: The Instruction For Example: "Fix the spelling mistake"
    ///   - model: The Model to use, the only support model is `text-davinci-edit-001`
    ///   - input: The Input For Example "My nam is Adam"
    ///   - completionHandler: Returns an OpenAI Data Model
    public func sendEdits(with instruction: String, model: OpenAIModelType = .feature(.davinci), input: String = "", completionHandler: @escaping (Result<OpenAI<TextResult>, OpenAIError>) -> Void) {
        let endpoint = Endpoint.edits
        let body = Instruction(instruction: instruction, model: model.modelName, input: input)
        makeRequest(endpoint: endpoint, body: body, completionHandler: completionHandler)
    }
    
    /// Send a Chat request to the OpenAI API
    /// - Parameters:
    ///   - messages: Array of `ChatMessages`
    ///   - model: The Model to use, the only support model is `gpt-3.5-turbo`
    ///   - user: A unique identifier representing your end-user, which can help OpenAI to monitor and detect abuse.
    ///   - temperature: What sampling temperature to use, between 0 and 2. Higher values like 0.8 will make the output more random, while lower values like 0.2 will make it more focused and deterministic. We generally recommend altering this or topProbabilityMass but not both.
    ///   - topProbabilityMass: The OpenAI api equivalent of the "top_p" parameter. An alternative to sampling with temperature, called nucleus sampling, where the model considers the results of the tokens with top_p probability mass. So 0.1 means only the tokens comprising the top 10% probability mass are considered. We generally recommend altering this or temperature but not both.
    ///   - choices: How many chat completion choices to generate for each input message.
    ///   - stop: Up to 4 sequences where the API will stop generating further tokens.
    ///   - maxTokens: The maximum number of tokens allowed for the generated answer. By default, the number of tokens the model can return will be (4096 - prompt tokens).
    ///   - presencePenalty: Number between -2.0 and 2.0. Positive values penalize new tokens based on whether they appear in the text so far, increasing the model's likelihood to talk about new topics.
    ///   - frequencyPenalty: Number between -2.0 and 2.0. Positive values penalize new tokens based on their existing frequency in the text so far, decreasing the model's likelihood to repeat the same line verbatim.
    ///   - completionHandler: Returns an OpenAI Data Model
    public func sendChat(with messages: [ChatMessage],
                         model: OpenAIModelType = .chat(.chatgpt),
                         user: String? = nil,
                         temperature: Double? = 1,
                         topProbabilityMass: Double? = 0,
                         choices: Int? = 1,
                         stop: [String]? = nil,
                         maxTokens: Int? = nil,
                         presencePenalty: Double? = 0,
                         frequencyPenalty: Double? = 0,
                         completionHandler: @escaping (Result<OpenAI<MessageResult>, OpenAIError>) -> Void) {
        let endpoint = Endpoint.chat
        let body = ChatConversation(user: user,
                                    messages: messages,
                                    model: model.modelName,
                                    temperature: temperature,
                                    topProbabilityMass: topProbabilityMass,
                                    choices: choices,
                                    stop: stop,
                                    maxTokens: maxTokens,
                                    presencePenalty: presencePenalty,
                                    frequencyPenalty: frequencyPenalty)
        makeRequest(endpoint: endpoint, body: body, completionHandler: completionHandler)
    }
    
    private func makeRequest<BodyType: Encodable, T: Payload>(endpoint: Endpoint, body: BodyType, completionHandler: @escaping (Result<OpenAI<T>, OpenAIError>) -> Void) {
        guard let request = prepareRequest(endpoint, body: body) else {
            completionHandler(.failure(.decodingError(error: RequestError())))
            return
        }
        let task = urlSession.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completionHandler(.failure(.genericError(error: error)))
            } else if let data = data {
                do {
                    let res = try JSONDecoder().decode(OpenAI<T>.self, from: data)
                    completionHandler(.success(res))
                } catch {
                    if let errorRes = try? JSONDecoder().decode(ResponseError.self, from: data) {
                        completionHandler(.failure(.internalError(error: errorRes.error)))
                    } else {
                        completionHandler(.failure(.decodingError(error: error)))
                    }
                }
            }
        }
        task.resume()
    }
    
    private func prepareRequest<BodyType: Encodable>(_ endpoint: Endpoint, body: BodyType) -> URLRequest? {
        guard let baseUrl = URL(string: endpoint.baseURL()) else {
            return nil
        }
        guard var urlComponents = URLComponents(url: baseUrl, resolvingAgainstBaseURL: true) else {
            return nil
        }
        urlComponents.path = endpoint.path
        guard let url = urlComponents.url else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
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
    ///   - temperature: Higher values like 0.8 will make the output more random, while lower values like 0.2 will make it more focused and deterministic. Defaults to 1
    /// - Returns: Returns an OpenAI Data Model
    @available(swift 5.5)
    @available(macOS 10.15, iOS 13, watchOS 6, tvOS 13, *)
    public func sendCompletion(with prompt: String, model: OpenAIModelType = .gpt3(.davinci), maxTokens: Int = 16, temperature: Double = 1) async throws -> OpenAI<TextResult> {
        return try await withCheckedThrowingContinuation { continuation in
            sendCompletion(with: prompt, model: model, maxTokens: maxTokens, temperature: temperature) { result in
                continuation.resume(with: result)
            }
        }
    }
    
    /// Send a Edit request to the OpenAI API
    /// - Parameters:
    ///   - instruction: The Instruction For Example: "Fix the spelling mistake"
    ///   - model: The Model to use, the only support model is `text-davinci-edit-001`
    ///   - input: The Input For Example "My nam is Adam"
    /// - Returns: Returns an OpenAI Data Model
    @available(swift 5.5)
    @available(macOS 10.15, iOS 13, watchOS 6, tvOS 13, *)
    public func sendEdits(with instruction: String, model: OpenAIModelType = .feature(.davinci), input: String = "") async throws -> OpenAI<TextResult> {
        return try await withCheckedThrowingContinuation { continuation in
            sendEdits(with: instruction, model: model, input: input) { result in
                continuation.resume(with: result)
            }
        }
    }
    
    /// Send a Chat request to the OpenAI API
    /// - Parameters:
    ///   - messages: Array of `ChatMessages`
    ///   - model: The Model to use, the only support model is `gpt-3.5-turbo`
    ///   - user: A unique identifier representing your end-user, which can help OpenAI to monitor and detect abuse.
    ///   - temperature: What sampling temperature to use, between 0 and 2. Higher values like 0.8 will make the output more random, while lower values like 0.2 will make it more focused and deterministic. We generally recommend altering this or topProbabilityMass but not both.
    ///   - topProbabilityMass: The OpenAI api equivalent of the "top_p" parameter. An alternative to sampling with temperature, called nucleus sampling, where the model considers the results of the tokens with top_p probability mass. So 0.1 means only the tokens comprising the top 10% probability mass are considered. We generally recommend altering this or temperature but not both.
    ///   - choices: How many chat completion choices to generate for each input message.
    ///   - stop: Up to 4 sequences where the API will stop generating further tokens.
    ///   - maxTokens: The maximum number of tokens allowed for the generated answer. By default, the number of tokens the model can return will be (4096 - prompt tokens).
    ///   - presencePenalty: Number between -2.0 and 2.0. Positive values penalize new tokens based on whether they appear in the text so far, increasing the model's likelihood to talk about new topics.
    ///   - frequencyPenalty: Number between -2.0 and 2.0. Positive values penalize new tokens based on their existing frequency in the text so far, decreasing the model's likelihood to repeat the same line verbatim.
    ///   - completionHandler: Returns an OpenAI Data Model
    @available(swift 5.5)
    @available(macOS 10.15, iOS 13, watchOS 6, tvOS 13, *)
    public func sendChat(with messages: [ChatMessage],
                         model: OpenAIModelType = .chat(.chatgpt),
                         user: String? = nil,
                         temperature: Double? = 1,
                         topProbabilityMass: Double? = 0,
                         choices: Int? = 1,
                         stop: [String]? = nil,
                         maxTokens: Int? = nil,
                         presencePenalty: Double? = 0,
                         frequencyPenalty: Double? = 0) async throws -> OpenAI<MessageResult> {
        return try await withCheckedThrowingContinuation { continuation in
            sendChat(with: messages,
                     model: model,
                     user: user,
                     temperature: temperature,
                     topProbabilityMass: topProbabilityMass,
                     choices: choices,
                     stop: stop,
                     maxTokens: maxTokens,
                     presencePenalty: presencePenalty,
                     frequencyPenalty: frequencyPenalty) { result in
                continuation.resume(with: result)
            }
        }
    }
}
