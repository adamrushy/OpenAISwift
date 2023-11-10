//
//  File.swift
//  
//
//  Created by Mark Hoath on 10/11/2023.
//

import Foundation

extension OpenAISwift {
    
    /// Send a Chat request to the OpenAI API
    /// - Parameters:
    ///   - messages: Array of `ChatMessages`
    ///   - model: The Model to use.
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
                         model: OpenAIEndpointModelType.ChatCompletions = .gpt35Turbo,
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
                                    model: model.rawValue,
                                    temperature: temperature,
                                    topProbabilityMass: topProbabilityMass,
                                    choices: choices,
                                    stop: stop,
                                    maxTokens: maxTokens,
                                    presencePenalty: presencePenalty,
                                    frequencyPenalty: frequencyPenalty,
                                    logitBias: logitBias,
                                    stream: false)

        let request = prepareRequest(endpoint, body: body)

        makeRequest(request: request) { result in
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

    /// Send a Chat request to the OpenAI API
    @available(*, deprecated, message: "Use method with `OpenAIEndpointModelType.ChatCompletions` instead")
    public func sendChat(with messages: [ChatMessage],
                         model: OpenAIModelType,
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
        guard let model = OpenAIEndpointModelType.ChatCompletions(rawValue: model.modelName) else {
            preconditionFailure("Model \(model.modelName) not supported")
        }
        sendChat(
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
            completionHandler: completionHandler)
    }

    /// Send a Chat request to the OpenAI API with stream enabled
    /// - Parameters:
    ///   - messages: Array of `ChatMessages`
    ///   - model: The Model to use.
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
                                  model: OpenAIEndpointModelType.ChatCompletions = .gpt35Turbo,
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
                                    model: model.rawValue,
                                    temperature: temperature,
                                    topProbabilityMass: topProbabilityMass,
                                    choices: choices,
                                    stop: stop,
                                    maxTokens: maxTokens,
                                    presencePenalty: presencePenalty,
                                    frequencyPenalty: frequencyPenalty,
                                    logitBias: logitBias,
                                    stream: true)
        let request = prepareRequest(endpoint, body: body)
        handler.onEventReceived = onEventReceived
        handler.onComplete = onComplete
        handler.connect(with: request)
    }

    /// Send a Chat request to the OpenAI API with stream enabled
    @available(*, deprecated, message: "Use method with `OpenAIEndpointModelType.ChatCompletions` instead")
    public func sendStreamingChat(with messages: [ChatMessage],
                                  model: OpenAIModelType,
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
        guard let model = OpenAIEndpointModelType.ChatCompletions(rawValue: model.modelName) else {
            preconditionFailure("Model \(model.modelName) not supported")
        }
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
            onEventReceived: onEventReceived,
            onComplete: onComplete)
    }

    
    /// Send a Chat request to the OpenAI API
    /// - Parameters:
    ///   - messages: Array of `ChatMessages`
    ///   - model: The Model to use.
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
                         model: OpenAIEndpointModelType.ChatCompletions = .gpt35Turbo,
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

    /// Send a Chat request to the OpenAI API
    @available(swift 5.5)
    @available(macOS 10.15, iOS 13, watchOS 6, tvOS 13, *)
    @available(*, deprecated, message: "Use method with `OpenAIEndpointModelType.ChatCompletions` instead")
    public func sendChat(with messages: [ChatMessage],
                         model: OpenAIModelType,
                         user: String? = nil,
                         temperature: Double? = 1,
                         topProbabilityMass: Double? = 0,
                         choices: Int? = 1,
                         stop: [String]? = nil,
                         maxTokens: Int? = nil,
                         presencePenalty: Double? = 0,
                         frequencyPenalty: Double? = 0,
                         logitBias: [Int: Double]? = nil) async throws -> OpenAI<MessageResult> {
        guard let model = OpenAIEndpointModelType.ChatCompletions(rawValue: model.modelName) else {
            preconditionFailure("Model \(model.modelName) not supported")
        }
        return try await sendChat(with: messages,
                                  model: model,
                                  user: user,
                                  temperature: temperature,
                                  topProbabilityMass: topProbabilityMass,
                                  choices: choices,
                                  stop: stop,
                                  maxTokens: maxTokens,
                                  presencePenalty: presencePenalty,
                                  frequencyPenalty: frequencyPenalty,
                                  logitBias: logitBias)
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
                                  model: OpenAIEndpointModelType.ChatCompletions = .gpt35Turbo,
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

    /// Send a Chat request to the OpenAI API with stream enabled
    @available(swift 5.5)
    @available(macOS 10.15, iOS 13, watchOS 6, tvOS 13, *)
    @available(*, deprecated, message: "Use method with `OpenAIEndpointModelType.ChatCompletions` instead")
    public func sendStreamingChat(with messages: [ChatMessage],
                                  model: OpenAIModelType,
                                  user: String? = nil,
                                  temperature: Double? = 1,
                                  topProbabilityMass: Double? = 0,
                                  choices: Int? = 1,
                                  stop: [String]? = nil,
                                  maxTokens: Int? = nil,
                                  presencePenalty: Double? = 0,
                                  frequencyPenalty: Double? = 0,
                                  logitBias: [Int: Double]? = nil) -> AsyncStream<Result<OpenAI<StreamMessageResult>, OpenAIError>> {
        guard let model = OpenAIEndpointModelType.ChatCompletions(rawValue: model.modelName) else {
            preconditionFailure("Model \(model.modelName) not supported")
        }
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

}
