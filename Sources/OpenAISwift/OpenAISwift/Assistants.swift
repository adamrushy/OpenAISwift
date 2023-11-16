//
//  Assistants.swift
//  
//
//  Created by Mark Hoath on 14/11/2023.
//

import Foundation

extension OpenAISwift {
    
    /// createAssistant  request to the OpenAI API
    /// - Parameters:
    ///   - model: ID of the model to use. You can use the List models API to see all of your available models, or see our Model overview for descriptions of them.
    ///   - name: The name of the assistant. The maximum length is 256 characters.
    ///   - description: The description of the assistant. The maximum length is 512 characters.
    ///   - instructions: The system instructions that the assistant uses. The maximum length is 32768 characters.
    ///   - tools: A list of tool enabled on the assistant. There can be a maximum of 128 tools per assistant. Tools can be of types code_interpreter, retrieval, or function.
    ///   - file_ids: A list of file IDs attached to this assistant. There can be a maximum of 20 files attached to the assistant. Files are ordered by their creation date in ascending order.
    ///   - metadata:Set of 16 key-value pairs that can be attached to an object. This can be useful for storing additional information about the object in a structured format. Keys can be a maximum of 64 characters long and values can be a maxium of 512 characters long.
    ///
    ///   - completionHandler: Returns an Assistant Object

    public func createAssistant(model: String, name: String?, description: String?, instructions: String?, tools: [Tools]?, file_ids: [String]?, metadata: [String:String]?, completionHandler: @escaping (Result<OpenAI<UrlResult>, OpenAIError>) -> Void) {
        
        let endpoint = OpenAIEndpointProvider.API.assistant_create
        let body = AssistantBody(model: model, name: name, description: description, instructions: instructions, tools: tools, file_ids: file_ids, metadata: metadata)
        let request = prepareRequest(endpoint, body: body, queryItems: nil)

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

    /// retrieveAssistant  request to the OpenAI API
    /// - Parameters:
    ///   - assistant_id: The ID of the assistant to retrieve
    ///
    ///   - completionHandler: Returns an Assistant Object

    public func retrieveAssistant(assistant_id: String, completionHandler: @escaping (Result<OpenAI<UrlResult>, OpenAIError>) -> Void) {
        
        let endpoint = OpenAIEndpointProvider.API.assistant_retrieve
        var request = prepareRequest(endpoint, queryItems: nil)
        
        request.url?.appendPathComponent("/\(assistant_id)")

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

    /// modifyAssistant  request to the OpenAI API
    /// - Parameters:
    ///   - assistant_id: The ID of the assistant to modify
    ///
    ///   - model: ID of the model to use. You can use the List models API to see all of your available models, or see our Model overview for descriptions of them.
    ///   - name: The name of the assistant. The maximum length is 256 characters.
    ///   - description: The description of the assistant. The maximum length is 512 characters.
    ///   - instructions: The system instructions that the assistant uses. The maximum length is 32768 characters.
    ///   - tools: A list of tool enabled on the assistant. There can be a maximum of 128 tools per assistant. Tools can be of types code_interpreter, retrieval, or function.
    ///   - file_ids: A list of file IDs attached to this assistant. There can be a maximum of 20 files attached to the assistant. Files are ordered by their creation date in ascending order.
    ///   - metadata:Set of 16 key-value pairs that can be attached to an object. This can be useful for storing additional information about the object in a structured format. Keys can be a maximum of 64 characters long and values can be a maxium of 512 characters long.
    ///
    ///   - completionHandler: Returns an Assistant Object

    public func modifyAssistant(assistant_id: String, model: String, name: String?, description: String?, instructions: String?, tools: [Tools]?, file_ids: [String]?, metadata: [String:String]?, completionHandler: @escaping (Result<OpenAI<UrlResult>, OpenAIError>) -> Void) {
        
        let endpoint = OpenAIEndpointProvider.API.assistant_modify
        let body = AssistantBody(model: model, name: name, description: description, instructions: instructions, tools: tools, file_ids: file_ids, metadata: metadata)
        var request = prepareRequest(endpoint, body: body, queryItems: nil)
        request.url?.appendPathComponent("/\(assistant_id)")

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
    
    /// deleteAssistant  request to the OpenAI API
    /// - Parameters:
    ///   - assistant_id: The ID of the assistant to modify
    ///   - completionHandler: Returns the Deletion Status

    public func deleteAssistant(assistant_id: String , completionHandler: @escaping (Result<OpenAI<UrlResult>, OpenAIError>) -> Void) {
        
        let endpoint = OpenAIEndpointProvider.API.assistant_delete

        var request = prepareRequest(endpoint, queryItems: nil)
        request.url?.appendPathComponent("/\(assistant_id)")

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
    /// listAssistants  request to the OpenAI API
    /// - Parameters:
    ///   - limit: Optional. A limit on the number of objects to be returned. Limit can range between 1 and 100, and the default is 20.
    ///   - order: Optional.Sort order by the created_at timestamp of the objects. asc for ascending order and desc for descending order. Default is DESC
    ///   - after: Optional. A cursor for use in pagination. after is an object ID that defines your place in the list. For instance, if you make a list request and receive 100 objects, 
    ///             ending with obj_foo, your subsequent call can include after=obj_foo in order to fetch the next page of the list.
    ///   - before:  Optional. A cursor for use in pagination. before is an object ID that defines your place in the list. For instance, if you make a list request and receive 100 objects,
    ///             ending with obj_foo, your subsequent call can include before=obj_foo in order to fetch the previous page of the list.
    ///
    ///   - completionHandler: Returns a List of Assistant Objects

    public func listAssistants(limit: Int?, order: String?, after: String?, before: String? , completionHandler: @escaping (Result<OpenAI<UrlResult>, OpenAIError>) -> Void) {
        
        let endpoint = OpenAIEndpointProvider.API.assistant_retrieve
        
        let laqp = ListAssistantParams(limit: limit, order: order, after: after, before: before)
        
        var queryItems: [URLQueryItem] = []
        
        if let parameters = laqp.toDictionary() {
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

        let request = prepareRequest(endpoint, queryItems: queryItems)
        
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
