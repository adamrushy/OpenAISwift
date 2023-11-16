//
//  Messages.swift
//  
//
//  Created by Mark Hoath on 14/11/2023.
//

import Foundation


extension OpenAISwift {
    
    /// createMessage request to the OpenAI API
    /// - Parameters:
    ///   - thread_id: The ID of the thread to create a message for.
    ///   - role: The role of the entity that is creating the message. Currently only user is supported.
    ///   - content The content of the message.
    ///   - file_ids: Optional. A list of File IDs that the message should use. There can be a maximum of 10 files attached to a message.
    ///   - metadata: Optional. Set of 16 key-value pairs that can be attached to an object. This can be useful for storing additional information about the object in a structured format. Keys can be a maximum of 64 characters long and values can be a maxium of 512 characters long.
    ///
    ///   - completionHandler: Returns a Message Object

    public func createMessage(thread_id: String, role: String, content: String, file_ids: [String]?, metadata: [String:String]? , completionHandler: @escaping (Result<OpenAI<UrlResult>, OpenAIError>) -> Void) {
        
        let endpoint = OpenAIEndpointProvider.API.messages_create
        
        let body = Message(role: role, content: content, file_ids: file_ids, metadata: metadata)
        
        var request = prepareRequest(endpoint, body: body, queryItems: nil)
        
        request.url?.appendPathComponent("/\(thread_id)/messages")

        makeRequest(request: request) { result in
            
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
    
    /// retrieveMessage request to the OpenAI API
    /// - Parameters:
    ///   - thread_id: The ID of the thread to create a message for.
    ///   - message_id: The ID of the message to retrieve

    ///
    ///   - completionHandler: Returns a Message Object

    public func retrieveMessage(thread_id: String, message_id: String , completionHandler: @escaping (Result<OpenAI<UrlResult>, OpenAIError>) -> Void) {
        
        let endpoint = OpenAIEndpointProvider.API.messages_retrieve
                
        var request = prepareRequest(endpoint)
        
        request.url?.appendPathComponent("/\(thread_id)/messages/\(message_id)")

        makeRequest(request: request) { result in
            
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

    /// modifyMessage request to the OpenAI API
    /// - Parameters:
    ///   - thread_id: The ID of the thread to create a message for.
    ///   - message_id: The ID of the message to retrieve
    ///
    ///   - metadata: Optional. Set of 16 key-value pairs that can be attached to an object. This can be useful for storing additional information about the object in a structured format. Keys can be a maximum of 64 characters long and values can be a maxium of 512 characters long.

    ///
    ///   - completionHandler: Returns a Modified Message Object

    public func modifyMessage(thread_id: String, message_id: String, metadata: [String:String]?, completionHandler: @escaping (Result<OpenAI<UrlResult>, OpenAIError>) -> Void) {
        
        let endpoint = OpenAIEndpointProvider.API.messages_modify
        
        var request: URLRequest
                
        if metadata == nil {
            request = prepareRequest(endpoint)
        } else {
            request = prepareRequest(endpoint, body: metadata, queryItems: nil)
        }
        request.url?.appendPathComponent("/\(thread_id)/messages/\(message_id)")

        makeRequest(request: request) { result in
            
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

    /// listMessages request to the OpenAI API
    /// - Parameters:
    ///   - thread_id: The ID of the thread to create a message for.
    ///
    ///
    ///   - completionHandler: Returns a list of message objects

    public func listMessages(thread_id: String, limit: Int?, order: String?, after:String?, before:String?, completionHandler: @escaping (Result<OpenAI<UrlResult>, OpenAIError>) -> Void) {
        
        let endpoint = OpenAIEndpointProvider.API.messages_list
        
        let mlr = MessageListRequest(limit: limit, order: order, after: after, before: before)
        
        var queryItems: [URLQueryItem] = []
        
        if let parameters = mlr.toDictionary() {
            queryItems = parameters.compactMap{ key, value in
                if let stringValue = value as? String {
                    return URLQueryItem(name: key, value: stringValue)
                } else if let intValue = value as? Int {
                    return URLQueryItem(name: key, value: String(intValue))
                }
                // Add more cases here for other types if needed
                return nil
            }
        }
        
        var request = prepareRequest(endpoint, queryItems: queryItems)
        request.url?.appendPathComponent("/\(thread_id)/messages")

        makeRequest(request: request) { result in
            
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
