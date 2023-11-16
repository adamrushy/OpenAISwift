//
//  FineTunings.swift
//  
//
//  Created by Mark Hoath on 14/11/2023.
//

import Foundation

extension OpenAISwift {
    
    /// uploadFiles  request to the OpenAI API
    /// - Parameters:
    ///   - Model: The name of the model to fine-tune. You can select one of the supported models.
    ///   - training_file : The ID of an uploaded file that contains training data.
    ///   - hyperparameters: (Optional) The hyperparameters used for the fine-tuning job.
    ///   - suffix: (Optional) A string of up to 18 characters that will be added to your fine-tuned model name.
    ///   - validation_file: The ID of an uploaded file that contains validation data.
    ///
    ///   Use "fine-tune" for Fine-tuning and "assistants" for Assistants and Messages. This allows us to validate the format of the uploaded file is correct for fine-tuning.

    ///   - completionHandler: Returns an OpenAI Data Model

    public func createFineTuningJob(model: String, training_file: String, hyperparameters: FineTuningHyperParams?, suffix: String?, validation_file: String? , completionHandler: @escaping (Result<OpenAI<UrlResult>, OpenAIError>) -> Void) {
        
        let endpoint = OpenAIEndpointProvider.API.fine_tuning_create
                
        let body = FineTuningRequest(model: model, training_file: training_file, hyperparameters: hyperparameters, suffix: suffix, validation_file: validation_file)
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

    /// listFineTuningJobs  request to the OpenAI API
    /// - Parameters:
    ///   - after: Identifier for the last job from the previous pagination request. Optional
    ///   - limit: Number of fine-tuning jobs to retrieve. - Optional Defaults to 20

    ///   - completionHandler: Returns a list of fine-tuning Jobs.
    
    public func listFineTuningJobs(after: String?, limit: Int? , completionHandler: @escaping (Result<OpenAI<UrlResult>, OpenAIError>) -> Void) {
        
        let endpoint = OpenAIEndpointProvider.API.fine_tuning_list
        
        let ftlr = FineTuningListRequest(after: after, limit: limit)
        
        var queryItems: [URLQueryItem] = []
        
        if let parameters = ftlr.toDictionary() {
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

    /// retrieveFineTuningJob  request to the OpenAI API
    /// - Parameters:
    ///   - fine_tuning_job_id: The ID of the fine-tuning job.

    ///   - completionHandler: Returns the fine-tuning Object.
    
    public func retrieveFineTuningJob(fine_tuning_job_id: String, completionHandler: @escaping (Result<OpenAI<UrlResult>, OpenAIError>) -> Void) {
        
        let endpoint = OpenAIEndpointProvider.API.fine_tuning_retrieve
        var request = prepareRequest(endpoint, queryItems: nil)
        request.url?.appendPathComponent("/\(fine_tuning_job_id)")
        
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

    /// cancelFineTuningJob  request to the OpenAI API
    /// - Parameters:
    ///   - fine_tuning_job_id: The ID of the fine-tuning job to cancel.

    ///   - completionHandler: Returns the fine-tuning Object.
    
    public func cancelFineTuningJob(fine_tuning_job_id: String, completionHandler: @escaping (Result<OpenAI<UrlResult>, OpenAIError>) -> Void) {
        
        let endpoint = OpenAIEndpointProvider.API.fine_tuning_cancel
        var request = prepareRequest(endpoint, queryItems: nil)
        request.url?.appendPathComponent("/\(fine_tuning_job_id)/cancel")
        
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

    /// listFineTuningEvents  request to the OpenAI API
    /// - Parameters:
    ///   - fine_tuning_job_id: The ID of the fine-tuning job to cancel.

    ///   - completionHandler: Returns the fine-tuning Object.
    
    public func listFineTuningEvents(fine_tuning_job_id: String, after: String?, limit: Int?, completionHandler: @escaping (Result<OpenAI<UrlResult>, OpenAIError>) -> Void) {
        
        let endpoint = OpenAIEndpointProvider.API.fine_tuning_list_events
        let ftlr = FineTuningListRequest(after: after, limit: limit)
        
        var queryItems: [URLQueryItem] = []
        
        if let parameters = ftlr.toDictionary() {
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
        request.url?.appendPathComponent("/\(fine_tuning_job_id)/events")
        
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
