//
//  Files.swift
//  
//
//  Created by Mark Hoath on 14/11/2023.
//

import Foundation

extension OpenAISwift {
    
    /// listFiles  request to the OpenAI API
    /// - Parameters:
    ///   - purpose: Only return files with the given purpose.

    ///   - completionHandler: Returns an OpenAI Data Model
    
    public func listFiles(purpose: FilePurpose?, completionHandler: @escaping (Result<OpenAI<UrlResult>, OpenAIError>) -> Void) {
        
        let endpoint = OpenAIEndpointProvider.API.files_list
        
        let pur_request = FilesResquest(purpose: purpose?.rawValue)
        
        var queryItems: [URLQueryItem] = []
        
        if let parameters = pur_request.toDictionary() {
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
    
    /// uploadFiles  request to the OpenAI API
    /// - Parameters:
    ///   - File: The Data of the file to be uploaded.
    ///   - purpose: The intended purpose of the uploaded file.
    ///   Use "fine-tune" for Fine-tuning and "assistants" for Assistants and Messages. This allows us to validate the format of the uploaded file is correct for fine-tuning.

    ///   - completionHandler: Returns an OpenAI Data Model

    public func uploadFiles(file: Data, purpose: FilePurpose, completionHandler: @escaping (Result<OpenAI<UrlResult>, OpenAIError>) -> Void) {
        
        let endpoint = OpenAIEndpointProvider.API.files_upload

        let request = prepareMultipartFormFileDataRequest(endpoint, file: file, purpose: purpose.rawValue)

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

    /// deleteFiles  request to the OpenAI API
    /// - Parameters:
    ///   - file_id: The ID of the file to use for this request.

    ///   - completionHandler: Returns the deletion status
    
    public func deleteFiles(file_id: String, completionHandler: @escaping (Result<OpenAI<UrlResult>, OpenAIError>) -> Void) {
        
        let endpoint = OpenAIEndpointProvider.API.files_delete
        var request = prepareRequest(endpoint, queryItems: nil)
        
        request.url?.appendPathComponent(file_id)
        
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
    
    /// retrieveFile  request to the OpenAI API
    /// - Parameters:
    ///   - file_id: The ID of the file to use for this request.

    ///   - completionHandler: Returns the file object

    
    public func retrieveFile(file_id: String, completionHandler: @escaping (Result<OpenAI<UrlResult>, OpenAIError>) -> Void) {
        
        let endpoint = OpenAIEndpointProvider.API.files_delete
        var request = prepareRequest(endpoint, queryItems: nil)
        
        request.url?.appendPathComponent(file_id)
        
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

    /// retrieveFileContent  request to the OpenAI API
    /// - Parameters:
    ///   - file_id: The ID of the file to use for this request.

    ///   - completionHandler: Returns the file content

    
    public func retrieveFileContent(file_id: String, completionHandler: @escaping (Result<OpenAI<UrlResult>, OpenAIError>) -> Void) {
        
        let endpoint = OpenAIEndpointProvider.API.files_delete
        
        var request = prepareRequest(endpoint, queryItems: nil)
        
        request.url?.appendPathComponent(file_id)
        request.url?.appendPathComponent("/content")

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
