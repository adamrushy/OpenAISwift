//
//  Models.swift
//  
//
//  Created by Mark Hoath on 14/11/2023.
//

import Foundation

//    case models_list
//    case models_retrieve
//    case models_delete


extension OpenAISwift {
    
    /// listModels  Lists the currently available models, and provides basic information about each one such as the owner and availability.
    /// - Parameters:
    ///
    ///   - completionHandler: Returns a list of model Objects
    
    public func listModels( completionHandler: @escaping (Result<OpenAI<UrlResult>, OpenAIError>) -> Void) {
        
        let endpoint = OpenAIEndpointProvider.API.models_list
        let body = ""
        let request = prepareRequest(endpoint, body: body)

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
    

    /// retrieveModel  Retrieves a model instance, providing basic information about the model such as the owner and permissioning.
    /// - Parameters:
    ///   - model: String. The ID of the model to use for this request.
    ///
    ///   - completionHandler: Returns a model Object
    
    public func retrieveModel(model: String, completionHandler: @escaping (Result<OpenAI<UrlResult>, OpenAIError>) -> Void) {
        
        let endpoint = OpenAIEndpointProvider.API.models_retrieve
        let body = ""
        var request = prepareRequest(endpoint, body: body)
        
        request.url?.appendPathComponent("/\(model)")

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
    

    /// deleteModel  Delete a fine-tuned model. You must have the Owner role in your organization to delete a model.
    /// - Parameters:
    ///
    ///   - model: String. The ID of the model to use for this request.
    ///   - completionHandler: Returns deletion status
    
    public func deleteModel(model: String,  completionHandler: @escaping (Result<OpenAI<UrlResult>, OpenAIError>) -> Void) {
        
        let endpoint = OpenAIEndpointProvider.API.models_delete
        let body = ""
        var request = prepareRequest(endpoint, body: body)

        request.url?.appendPathComponent("/\(model)")

        
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
