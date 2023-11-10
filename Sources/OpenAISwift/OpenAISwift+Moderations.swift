//
//  File.swift
//  
//
//  Created by Mark Hoath on 10/11/2023.
//

import Foundation

extension OpenAISwift {
    
    /// Send a Moderation request to the OpenAI API
    /// - Parameters:
    ///   - input: The Input For Example "My nam is Adam"
    ///   - model: The Model to use
    ///   - completionHandler: Returns an OpenAI Data Model
    public func sendModerations(with input: String, model: OpenAIEndpointModelType.Moderations = .textModerationLatest, completionHandler: @escaping (Result<OpenAI<ModerationResult>, OpenAIError>) -> Void) {
        let endpoint = OpenAIEndpointProvider.API.moderations
        let body = Moderation(input: input, model: model.rawValue)
        let request = prepareRequest(endpoint, body: body)

        makeRequest(request: request) { result in
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

    /// Send a Moderation request to the OpenAI API
    @available(*, deprecated, message: "Use method with `OpenAIEndpointModelType.Moderations` instead")
    public func sendModerations(with input: String, model: OpenAIModelType, completionHandler: @escaping (Result<OpenAI<ModerationResult>, OpenAIError>) -> Void) {
        guard let model = OpenAIEndpointModelType.Moderations(rawValue: model.modelName) else {
            preconditionFailure("Model \(model.modelName) not supported")
        }
        sendModerations(with: input,
                        model: model,
                        completionHandler: completionHandler
        )
    }

    
    /// Send a Moderation request to the OpenAI API
    /// - Parameters:
    ///   - input: The Input For Example "My nam is Adam"
    ///   - model: The Model to use
    /// - Returns: Returns an OpenAI Data Model
    @available(swift 5.5)
    @available(macOS 10.15, iOS 13, watchOS 6, tvOS 13, *)
    public func sendModerations(with input: String = "", model: OpenAIEndpointModelType.Moderations = .textModerationLatest) async throws -> OpenAI<ModerationResult> {
        return try await withCheckedThrowingContinuation { continuation in
            sendModerations(with: input, model: model) { result in
                continuation.resume(with: result)
            }
        }
    }

    /// Send a Moderation request to the OpenAI API
    @available(swift 5.5)
    @available(macOS 10.15, iOS 13, watchOS 6, tvOS 13, *)
    @available(*, deprecated, message: "Use method with `OpenAIEndpointModelType.Moderations` instead")
    public func sendModerations(with input: String = "", model: OpenAIModelType) async throws -> OpenAI<ModerationResult> {
        guard let model = OpenAIEndpointModelType.Moderations(rawValue: model.modelName) else {
            preconditionFailure("Model \(model.modelName) not supported")
        }
        return try await sendModerations(with: input, model: model)
    }

}
