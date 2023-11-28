import Foundation
#if canImport(FoundationNetworking) && canImport(FoundationXML)
import FoundationNetworking
import FoundationXML
#endif

public enum OpenAIError: Error {
    case genericError(error: Error)
    case decodingError(error: Error)
    case chatError(error: ChatError.Payload)
}

public class OpenAISwift {
    
    // Typealias for backward compatibility so allowing custom request makers
    // doesn't introduce breaking changes to the public API
    public typealias Config = URLSessionRequestHandler
    
    fileprivate let requestHandler: OpenAIRequestHandler
    
    /// Initialises OpenAISwift with a given request handler
    /// - Parameter requestHandler: The request handler to make requests with
    public init(requestHandler: OpenAIRequestHandler) {
        self.requestHandler = requestHandler
    }
    
    /// Deprecated initialiser for backwards API support to remove breaking change when introducing OpenAIRequestHandler protocol
    /// - Parameter config: The config to initialise with
    public init(config: Config) {
        self.requestHandler = config
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
        let endpoint = OpenAIEndpointProvider.API.completions
        let body = Command(prompt: prompt, model: model.modelName, maxTokens: maxTokens, temperature: temperature)
        
        requestHandler.makeRequest(endpoint, body: body) { result in
            switch result {
            case .success(let success):
                do {
                    let res = try JSONDecoder().decode(OpenAI<TextResult>.self, from: success)
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
    public func sendEdits(with instruction: String, model: OpenAIModelType = .feature(.davinci), input: String = "", completionHandler: @escaping (Result<OpenAI<TextResult>, OpenAIError>) -> Void) {
        let endpoint = OpenAIEndpointProvider.API.edits
        let body = Instruction(instruction: instruction, model: model.modelName, input: input)
        
        requestHandler.makeRequest(endpoint, body: body) { result in
            switch result {
            case .success(let success):
                do {
                    let res = try JSONDecoder().decode(OpenAI<TextResult>.self, from: success)
                    completionHandler(.success(res))
                } catch {
                    completionHandler(.failure(.decodingError(error: error)))
                }
            case .failure(let failure):
                completionHandler(.failure(.genericError(error: failure)))
            }
        }
    }
    
    /// Send a Moderation request to the OpenAI API
    /// - Parameters:
    ///   - input: The Input For Example "My nam is Adam"
    ///   - model: The Model to use
    ///   - completionHandler: Returns an OpenAI Data Model
    public func sendModerations(with input: String, model: OpenAIModelType = .moderation(.latest), completionHandler: @escaping (Result<OpenAI<ModerationResult>, OpenAIError>) -> Void) {
        let endpoint = OpenAIEndpointProvider.API.moderations
        let body = Moderation(input: input, model: model.modelName)
        
        requestHandler.makeRequest(endpoint, body: body) { result in
            switch result {
            case .success(let success):
                do {
                    let res = try JSONDecoder().decode(OpenAI<ModerationResult>.self, from: success)
                    completionHandler(.success(res))
                } catch {
                    completionHandler(.failure(.decodingError(error: error)))
                }
            case .failure(let failure):
                completionHandler(.failure(.genericError(error: failure)))
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
    ///   - logitBias: Modify the likelihood of specified tokens appearing in the completion. Maps tokens (specified by their token ID in the OpenAI Tokenizer—not English words) to an associated bias value from -100 to 100. Values between -1 and 1 should decrease or increase likelihood of selection; values like -100 or 100 should result in a ban or exclusive selection of the relevant token.
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
                         logitBias: [Int: Double]? = nil,
                         completionHandler: @escaping (Result<OpenAI<MessageResult>, OpenAIError>) -> Void) {
        let endpoint = OpenAIEndpointProvider.API.chat
        let body = ChatConversation(user: user,
                                    messages: messages,
                                    model: model.modelName,
                                    temperature: temperature,
                                    topProbabilityMass: topProbabilityMass,
                                    choices: choices,
                                    stop: stop,
                                    maxTokens: maxTokens,
                                    presencePenalty: presencePenalty,
                                    frequencyPenalty: frequencyPenalty,
                                    logitBias: logitBias,
                                    stream: false)
        
        requestHandler.makeRequest(endpoint, body: body) { result in
            switch result {
            case .success(let success):
                if let chatErr = try? JSONDecoder().decode(ChatError.self, from: success) as ChatError {
                    completionHandler(.failure(.chatError(error: chatErr.error)))
                    return
                }
                
                do {
                    let res = try JSONDecoder().decode(OpenAI<MessageResult>.self, from: success)
                    completionHandler(.success(res))
                } catch {
                    completionHandler(.failure(.decodingError(error: error)))
                }
                
            case .failure(let failure):
                completionHandler(.failure(.genericError(error: failure)))
            }
        }
    }
    
    /// Send a Embeddings request to the OpenAI API
    /// - Parameters:
    ///   - input: The Input For Example "The food was delicious and the waiter..."
    ///   - model: The Model to use, the only support model is `text-embedding-ada-002`
    ///   - completionHandler: Returns an OpenAI Data Model
    public func sendEmbeddings(with input: String,
                               model: OpenAIModelType = .embedding(.ada),
                               completionHandler: @escaping (Result<OpenAI<EmbeddingResult>, OpenAIError>) -> Void) {
        let endpoint = OpenAIEndpointProvider.API.embeddings
        let body = EmbeddingsInput(input: input,
                                   model: model.modelName)
        
        requestHandler.makeRequest(endpoint, body: body) { result in
            switch result {
                case .success(let success):
                    do {
                        let res = try JSONDecoder().decode(OpenAI<EmbeddingResult>.self, from: success)
                        completionHandler(.success(res))
                    } catch {
                        completionHandler(.failure(.decodingError(error: error)))
                    }
                case .failure(let failure):
                    completionHandler(.failure(.genericError(error: failure)))
            }
        }
    }
    
    /// Send a Chat request to the OpenAI API with stream enabled
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
    ///   - logitBias: Modify the likelihood of specified tokens appearing in the completion. Maps tokens (specified by their token ID in the OpenAI Tokenizer—not English words) to an associated bias value from -100 to 100. Values between -1 and 1 should decrease or increase likelihood of selection; values like -100 or 100 should result in a ban or exclusive selection of the relevant token.
    ///   - onEventReceived: Called Multiple times, returns an OpenAI Data Model
    ///   - onComplete: Triggers when sever complete sending the message
    public func sendStreamingChat(with messages: [ChatMessage],
                                  model: OpenAIModelType = .chat(.chatgpt),
                                  user: String? = nil,
                                  temperature: Double? = 1,
                                  topProbabilityMass: Double? = 0,
                                  choices: Int? = 1,
                                  stop: [String]? = nil,
                                  maxTokens: Int? = nil,
                                  presencePenalty: Double? = 0,
                                  frequencyPenalty: Double? = 0,
                                  logitBias: [Int: Double]? = nil,
                                  onEventReceived: ((Result<OpenAI<StreamMessageResult>, OpenAIError>) -> Void)? = nil,
                                  onComplete: (() -> Void)? = nil) {
        let endpoint = OpenAIEndpointProvider.API.chat
        let body = ChatConversation(user: user,
                                    messages: messages,
                                    model: model.modelName,
                                    temperature: temperature,
                                    topProbabilityMass: topProbabilityMass,
                                    choices: choices,
                                    stop: stop,
                                    maxTokens: maxTokens,
                                    presencePenalty: presencePenalty,
                                    frequencyPenalty: frequencyPenalty,
                                    logitBias: logitBias,
                                    stream: true)
        
        requestHandler.streamRequest(endpoint, body: body, eventReceived: onEventReceived, completion: onComplete)
    }


    /// Send a Image generation request to the OpenAI API
    /// - Parameters:
    ///   - prompt: The Text Prompt
    ///   - numImages: The number of images to generate, defaults to 1
    ///   - size: The size of the image, defaults to 1024x1024. There are two other options: 512x512 and 256x256
    ///   - user: An optional unique identifier representing your end-user, which can help OpenAI to monitor and detect abuse.
    ///   - completionHandler: Returns an OpenAI Data Model
    public func sendImages(with prompt: String, numImages: Int = 1, size: ImageSize = .size1024, user: String? = nil, completionHandler: @escaping (Result<OpenAI<UrlResult>, OpenAIError>) -> Void) {
        let endpoint = OpenAIEndpointProvider.API.images
        let body = ImageGeneration(prompt: prompt, n: numImages, size: size, user: user)
        
        requestHandler.makeRequest(endpoint, body: body) { result in
            switch result {
                case .success(let success):
                    do {
                        let res = try JSONDecoder().decode(OpenAI<UrlResult>.self, from: success)
                        completionHandler(.success(res))
                    } catch {
                        completionHandler(.failure(.decodingError(error: error)))
                    }
                case .failure(let failure):
                    completionHandler(.failure(.genericError(error: failure)))
                }
        }
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
    ///   - logitBias: Modify the likelihood of specified tokens appearing in the completion. Maps tokens (specified by their token ID in the OpenAI Tokenizer—not English words) to an associated bias value from -100 to 100. Values between -1 and 1 should decrease or increase likelihood of selection; values like -100 or 100 should result in a ban or exclusive selection of the relevant token.
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
                         frequencyPenalty: Double? = 0,
                         logitBias: [Int: Double]? = nil) async throws -> OpenAI<MessageResult> {
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
                     frequencyPenalty: frequencyPenalty,
                     logitBias: logitBias) { result in
                switch result {
                    case .success: continuation.resume(with: result)
                    case .failure(let failure): continuation.resume(throwing: failure)
                }
            }
        }
    }
    
    
    /// Send a Chat request to the OpenAI API with stream enabled
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
    ///   - logitBias: Modify the likelihood of specified tokens appearing in the completion. Maps tokens (specified by their token ID in the OpenAI Tokenizer—not English words) to an associated bias value from -100 to 100. Values between -1 and 1 should decrease or increase likelihood of selection; values like -100 or 100 should result in a ban or exclusive selection of the relevant token.
    /// - Returns: Returns an OpenAI Data Model
    @available(swift 5.5)
    @available(macOS 10.15, iOS 13, watchOS 6, tvOS 13, *)
    public func sendStreamingChat(with messages: [ChatMessage],
                                  model: OpenAIModelType = .chat(.chatgpt),
                                  user: String? = nil,
                                  temperature: Double? = 1,
                                  topProbabilityMass: Double? = 0,
                                  choices: Int? = 1,
                                  stop: [String]? = nil,
                                  maxTokens: Int? = nil,
                                  presencePenalty: Double? = 0,
                                  frequencyPenalty: Double? = 0,
                                  logitBias: [Int: Double]? = nil) -> AsyncStream<Result<OpenAI<StreamMessageResult>, OpenAIError>> {
        return AsyncStream { continuation in
            sendStreamingChat(
                with: messages,
                model: model,
                user: user,
                temperature: temperature,
                topProbabilityMass: topProbabilityMass,
                choices: choices,
                stop: stop,
                maxTokens: maxTokens,
                presencePenalty: presencePenalty,
                frequencyPenalty: frequencyPenalty,
                logitBias: logitBias,
                onEventReceived: { result in
                    continuation.yield(result)
                }) {
                    continuation.finish()
                }
        }
    }

    /// Send a Embeddings request to the OpenAI API
    /// - Parameters:
    ///   - input: The Input For Example "The food was delicious and the waiter..."
    ///   - model: The Model to use, the only support model is `text-embedding-ada-002`
    ///   - completionHandler: Returns an OpenAI Data Model
    @available(swift 5.5)
    @available(macOS 10.15, iOS 13, watchOS 6, tvOS 13, *)
    public func sendEmbeddings(with input: String,
                               model: OpenAIModelType = .embedding(.ada)) async throws -> OpenAI<EmbeddingResult> {
        return try await withCheckedThrowingContinuation { continuation in
            sendEmbeddings(with: input) { result in
                continuation.resume(with: result)
            }
        }
    }
    
    /// Send a Moderation request to the OpenAI API
    /// - Parameters:
    ///   - input: The Input For Example "My nam is Adam"
    ///   - model: The Model to use
    /// - Returns: Returns an OpenAI Data Model
    @available(swift 5.5)
    @available(macOS 10.15, iOS 13, watchOS 6, tvOS 13, *)
    public func sendModerations(with input: String = "", model: OpenAIModelType = .moderation(.latest)) async throws -> OpenAI<ModerationResult> {
        return try await withCheckedThrowingContinuation { continuation in
            sendModerations(with: input, model: model) { result in
                continuation.resume(with: result)
            }
        }
    }
    
    /// Send a Image generation request to the OpenAI API
    /// - Parameters:
    ///   - prompt: The Text Prompt
    ///   - numImages: The number of images to generate, defaults to 1
    ///   - size: The size of the image, defaults to 1024x1024. There are two other options: 512x512 and 256x256
    ///   - user: An optional unique identifier representing your end-user, which can help OpenAI to monitor and detect abuse.
    /// - Returns: Returns an OpenAI Data Model
    @available(swift 5.5)
    @available(macOS 10.15, iOS 13, watchOS 6, tvOS 13, *)
    public func sendImages(with prompt: String, numImages: Int = 1, size: ImageSize = .size1024, user: String? = nil) async throws -> OpenAI<UrlResult> {
        return try await withCheckedThrowingContinuation { continuation in
            sendImages(with: prompt, numImages: numImages, size: size, user: user) { result in
                continuation.resume(with: result)
            }
        }
    }
}
