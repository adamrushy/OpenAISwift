//
//  Threads.swift
//  
//
//  Created by Mark Hoath on 14/11/2023.
//

import Foundation

extension OpenAISwift {
    
    /// createThread  request to the OpenAI API
    /// - Parameters:
    ///   - messages: Optional. An array of messages to start the thread with.
    ///
    ///   - completionHandler: Returns a Thread Object

    public func createThread(messages: [Message]?, completionHandler: @escaping (Result<OpenAI<UrlResult>, OpenAIError>) -> Void) {
        
        let endpoint = OpenAIEndpointProvider.API.thread_create
        
        var request: URLRequest
        
        if messages == nil {
            request = prepareRequest(endpoint, queryItems: nil)
        } else {
            request = prepareRequest(endpoint, body: messages, queryItems: nil)
        }

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

    /// retrieveThread  request to the OpenAI API
    /// - Parameters:
    ///   - thread_id: The ID of the thread to retrieve.
    ///
    ///   - completionHandler: Returns a Thread Object

    public func retrieveThread(thread_id: String, completionHandler: @escaping (Result<OpenAI<UrlResult>, OpenAIError>) -> Void) {
        
        let endpoint = OpenAIEndpointProvider.API.thread_retrieve
                
        var request = prepareRequest(endpoint, queryItems: nil)

        request.url?.appendPathComponent("/\thread_id")
        
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

    /// modifyThread  request to the OpenAI API
    /// - Parameters:
    ///   - thread_id: The ID of the thread to retrieve.
    ///   - metadata: Optional. Set of 16 key-value pairs that can be attached to an object. This can be useful for storing additional information about the object in a structured format. Keys can be a maximum of 64 characters long and values can be a maxium of 512 characters long.
    ///
    ///   - completionHandler: Returns a Modified Thread Object

    public func modifyThread(thread_id: String, metadata: [String:String]? ,completionHandler: @escaping (Result<OpenAI<UrlResult>, OpenAIError>) -> Void) {
        
        let endpoint = OpenAIEndpointProvider.API.thread_modify
        
        var request: URLRequest
        
        if metadata == nil {
            request = prepareRequest(endpoint)
        } else {
            request = prepareRequest(endpoint, body: metadata, queryItems: nil)
        }
                
        request.url?.appendPathComponent("/\thread_id")
        
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
    
    /// deleteThread  request to the OpenAI API
    /// - Parameters:
    ///   - thread_id: The ID of the thread to retrieve.
    ///   -
    ///   - completionHandler: Deletion Status

    public func deleteThread(thread_id: String,completionHandler: @escaping (Result<OpenAI<UrlResult>, OpenAIError>) -> Void) {
        
        let endpoint = OpenAIEndpointProvider.API.thread_delete
        
        var request = prepareRequest(endpoint)
                
        request.url?.appendPathComponent("/\thread_id")
        
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
