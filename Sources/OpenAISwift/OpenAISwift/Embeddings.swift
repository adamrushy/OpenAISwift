//
//  Embeddings.swift
//  
//
//  Created by Mark Hoath on 10/11/2023.
//

import Foundation

extension OpenAISwift {
    /// Send a Embeddings request to the OpenAI API
    /// - Parameters:
    ///  - input: The Input For Example "The food was delicious and the waiter..."
    /// - model: The Model to use
    /// - completionHandler: Returns an OpenAI Data Model
    public func sendEmbeddings(with input: String,
                               model: OpenAIEndpointModelType.Embeddings = .textEmbeddingAda002,
                               completionHandler: @escaping (Result<OpenAI<EmbeddingResult>, OpenAIError>) -> Void) {
        let endpoint = OpenAIEndpointProvider.API.embeddings
        let body = EmbeddingsInput(input: input,
                                   model: model.rawValue)

        let request = prepareRequest(endpoint, body: body, queryItems: nil)
        makeRequest(request: request) { result in
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

    /// Send a Embeddings request to the OpenAI API
    /// - Parameters:
    ///   - input: The Input For Example "The food was delicious and the waiter..."
    ///   - model: The Model to use, the only support model is `text-embedding-ada-002`
    ///   - completionHandler: Returns an OpenAI Data Model
    @available(swift 5.5)
    @available(macOS 10.15, iOS 13, watchOS 6, tvOS 13, *)
    public func sendEmbeddings(with input: String,
                               model: OpenAIEndpointModelType.Embeddings = .textEmbeddingAda002) async throws -> OpenAI<EmbeddingResult> {
        return try await withCheckedThrowingContinuation { continuation in
            sendEmbeddings(with: input) { result in
                continuation.resume(with: result)
            }
        }
    }
}
