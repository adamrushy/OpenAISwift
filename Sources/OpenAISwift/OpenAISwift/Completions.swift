

import Foundation
#if canImport(FoundationNetworking) && canImport(FoundationXML)
import FoundationNetworking
import FoundationXML
#endif

extension OpenAISwift {
    
    /// Send a Completion to the OpenAI API
    /// - Parameters:
    ///   - prompt: The Text Prompt
    ///   - model: The AI Model to Use. Set to `OpenAIEndpointModelType.LegacyCompletions.davinci,` by default which is the most capable model
    ///   - maxTokens: The limit character for the returned response, defaults to 16 as per the API
    ///   - completionHandler: Returns an OpenAI Data Model
    /// - Note: OpenAI marked this endpoint as legacy
    public func sendCompletion(with prompt: String, model: OpenAIEndpointModelType.LegacyCompletions = .davinci, maxTokens: Int = 16, temperature: Double = 1, completionHandler: @escaping (Result<OpenAI<TextResult>, OpenAIError>) -> Void) {
        let endpoint = OpenAIEndpointProvider.API.completions
        let body = Command(prompt: prompt, model: model.rawValue, maxTokens: maxTokens, temperature: temperature)
        let request = prepareRequest(endpoint, body: body)

        makeRequest(request: request) { result in
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

    /// Send a Completion to the OpenAI API
    @available(*, deprecated, message: "Use method with `OpenAIEndpointModelType.LegacyCompletions` instead")
    public func sendCompletion(with prompt: String, model: OpenAIModelType, maxTokens: Int = 16, temperature: Double = 1, completionHandler: @escaping (Result<OpenAI<TextResult>, OpenAIError>) -> Void) {
        guard let model = OpenAIEndpointModelType.LegacyCompletions(rawValue: model.modelName) else {
            preconditionFailure("Model \(model.modelName) not supported")
        }
        sendCompletion(
            with: prompt,
            model: model,
            maxTokens: maxTokens,
            temperature: temperature,
            completionHandler: completionHandler)
    }
    
    /// Send a Completion to the OpenAI API
    /// - Parameters:
    ///   - prompt: The Text Prompt
    ///   - model: The AI Model to Use. Set to `OpenAIEndpointModelType.LegacyCompletions.davinci` by default which is the most capable model
    ///   - maxTokens: The limit character for the returned response, defaults to 16 as per the API
    ///   - temperature: Higher values like 0.8 will make the output more random, while lower values like 0.2 will make it more focused and deterministic. Defaults to 1
    /// - Returns: Returns an OpenAI Data Model
    /// - Note: OpenAI marked this endpoint as legacy
    @available(swift 5.5)
    @available(macOS 10.15, iOS 13, watchOS 6, tvOS 13, *)
    public func sendCompletion(with prompt: String, model: OpenAIEndpointModelType.LegacyCompletions = .davinci, maxTokens: Int = 16, temperature: Double = 1) async throws -> OpenAI<TextResult> {
        return try await withCheckedThrowingContinuation { continuation in
            sendCompletion(with: prompt, model: model, maxTokens: maxTokens, temperature: temperature) { result in
                continuation.resume(with: result)
            }
        }
    }

    /// Send a Completion to the OpenAI API
    @available(swift 5.5)
    @available(macOS 10.15, iOS 13, watchOS 6, tvOS 13, *)
    @available(*, deprecated, message: "Use method with `OpenAIEndpointModelType.LegacyCompletions` instead")
    public func sendCompletion(with prompt: String, model: OpenAIModelType, maxTokens: Int = 16, temperature: Double = 1) async throws -> OpenAI<TextResult> {
        guard let model = OpenAIEndpointModelType.LegacyCompletions(rawValue: model.modelName) else {
            preconditionFailure("Model \(model.modelName) not supported")
        }
        return try await sendCompletion(with: prompt, model: model, maxTokens: maxTokens, temperature: temperature)
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

}
