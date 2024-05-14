//
//  File.swift
//  
//
//  Created by Mark Hoath on 16/11/2023.
//

import Foundation

extension OpenAISwift {
    
    /// retrieveMessageFile request to the OpenAI API
    /// - Parameters:
    ///   - thread_id: The ID of the thread to create a message for.
    ///   - message_id: The ID of the message to retrieve
    ///   - file_id: The ID of the file being retrieved
    ///
    ///   - completionHandler: Returns a Message file

    public func retrieveMessageFiles(thread_id: String, message_id: String, file_id:String, completionHandler: @escaping (Result<OpenAI<UrlResult>, OpenAIError>) -> Void) {
        
        let endpoint = OpenAIEndpointProvider.API.retrieve_message_file
                
        var request = prepareRequest(endpoint)
        
        request.url?.appendPathComponent("/\(thread_id)/messages/\(message_id)/files/\(file_id)")

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
    
    /// listMessageFile request to the OpenAI API
    /// - Parameters:
    ///   - thread_id: The ID of the thread to create a message for.
    ///   - message_id: The ID of the message to retrieve
    ///
    ///   - completionHandler: Returns a Message file

    public func listMessageFiles(thread_id: String, message_id: String, limit: Int?, order: String?, after:String?, before:String?, completionHandler: @escaping (Result<OpenAI<UrlResult>, OpenAIError>) -> Void) {
        
        let endpoint = OpenAIEndpointProvider.API.list_message_file
        
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
        
        request.url?.appendPathComponent("/\(thread_id)/messages/\(message_id)/files")

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
