//
//  Runs.swift
//  
//
//  Created by Mark Hoath on 14/11/2023.
//

import Foundation

//    case runs_create
//    case runs_retrieve
//    case runs_modify
//    case runs_list
//    case runs_submit
//    case runs_cancel
//    case runs_thread_create
//    case run_step_retrive
//    case run_step_list


extension OpenAISwift {
    
    /// createRun request to the OpenAI API
    /// - Parameters:
    ///   - thread_id: The ID of the thread to run.
    ///   - assistant_id: The ID of the assistant to use to execute this run.
    ///   - model: Optional The ID of the Model to be used to execute this run. If a value is provided here, it will override the model associated with the assistant. If not, the model associated with the assistant will be used.
    ///   - instructions: Optional. Override the default system message of the assistant. This is useful for modifying the behavior on a per-run basis.
    ///   - tools: Optional. Override the tools the assistant can use for this run. This is useful for modifying the behavior on a per-run basis.
    ///   - metadata: Optional. Set of 16 key-value pairs that can be attached to an object. This can be useful for storing additional information about the object in a structured format. Keys can be a maximum of 64 characters long and values can be a maxium of 512 characters long.
    ///
    ///   - completionHandler: Returns a Run Object

    public func createRun(thread_id: String, assistant_id: String, model: String?, instructions: String?, tools: [Tools]?, metadata: [String:String]? , completionHandler: @escaping (Result<OpenAI<UrlResult>, OpenAIError>) -> Void) {
        
        let endpoint = OpenAIEndpointProvider.API.runs_create
        
        let body = RunRequest(assistant_id: assistant_id, model: model, instructions: instructions, tools: tools, metadata: metadata)
        var request = prepareRequest(endpoint, body: body, queryItems: nil)
        
        request.url?.appendPathComponent("/\(thread_id)/runs")

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
    
    /// retrieveRun request to the OpenAI API
    /// - Parameters:
    ///   - thread_id: The ID of the thread to create a message for.
    ///   - run_id: The ID of the message to retrieve
    ///
    ///   - completionHandler: Returns a Run Object

    public func retrieveMessage(thread_id: String, run_id: String , completionHandler: @escaping (Result<OpenAI<UrlResult>, OpenAIError>) -> Void) {
        
        let endpoint = OpenAIEndpointProvider.API.runs_retrieve
                
        var request = prepareRequest(endpoint)
        
        request.url?.appendPathComponent("/\(thread_id)/runs/\(run_id)")

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
    
    /// modifyRun request to the OpenAI API
    /// - Parameters:
    ///   - thread_id: The ID of the thread to create a message for.
    ///   - run_id: The ID of the run to modify
    ///
    ///   - metadata: Optional. Set of 16 key-value pairs that can be attached to an object. This can be useful for storing additional information about the object in a structured format. Keys can be a maximum of 64 characters long and values can be a maxium of 512 characters long.

    ///
    ///   - completionHandler: Returns a Modified Run Object

    public func modifyRun(thread_id: String, run_id: String, metadata: [String:String]?, completionHandler: @escaping (Result<OpenAI<UrlResult>, OpenAIError>) -> Void) {
        
        let endpoint = OpenAIEndpointProvider.API.runs_modify
        
        var request: URLRequest
                
        if metadata == nil {
            request = prepareRequest(endpoint)
        } else {
            request = prepareRequest(endpoint, body: metadata, queryItems: nil)
        }
        request.url?.appendPathComponent("/\(thread_id)/runs/\(run_id)")

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
    
    /// listruns request to the OpenAI API
    /// - Parameters:
    ///   - thread_id: The ID of the thread to create a message for.
    ///
    ///   - limit: Optional, A limit on the number of objects to be returned. Limit can range between 1 and 100, and the default is 20.
    ///   - order: Optional. Sort order by the created_at timestamp of the objects. asc for ascending order and desc for descending order.
    ///   - after: Optional. A cursor for use in pagination. after is an object ID that defines your place in the list.
    ///   - before: Optional. A cursor for use in pagination. before is an object ID that defines your place in the list.

    ///   - completionHandler: Returns a list of run objects

    public func listruns(thread_id: String, limit: Int?, order: String?, after:String?, before:String?, completionHandler: @escaping (Result<OpenAI<UrlResult>, OpenAIError>) -> Void) {
        
        let endpoint = OpenAIEndpointProvider.API.runs_list
        
        let rlr = RunListRequest(limit: limit, order: order, after: after, before: before)
        
        var queryItems: [URLQueryItem] = []
        
        if let parameters = rlr.toDictionary() {
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
        request.url?.appendPathComponent("/\(thread_id)/runs")

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

    /// runSubmit request to the OpenAI API
    /// - Parameters:
    ///   - thread_id: The ID of the thread to create a message for.
    ///   - run_id: The ID of the run that requires the tool output submission
    ///   - tool_outputs: A list of tools for which the outputs are being submitted.
    ///
    ///
    ///   - completionHandler: Returns the modified run object for the specified ID.

    public func runsSubmit(thread_id: String, run_id:String, tools_output: [ToolsOutput], completionHandler: @escaping (Result<OpenAI<UrlResult>, OpenAIError>) -> Void) {
        
        let endpoint = OpenAIEndpointProvider.API.runs_submit
        
        
        var request = prepareRequest(endpoint, body: tools_output, queryItems: nil)
        request.url?.appendPathComponent("/\(thread_id)/runs/\(run_id)/submit_tool_outputs")

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

    /// runCancel request to the OpenAI API
    /// - Parameters:
    ///   - thread_id: The ID of the thread to which this run belongs
    ///   - run_id: The ID of the run to cancel
    ///
    ///
    ///   - completionHandler: Returns the modified run object for the specified ID.

    public func runCancel(thread_id: String, run_id:String, completionHandler: @escaping (Result<OpenAI<UrlResult>, OpenAIError>) -> Void) {
        
        let endpoint = OpenAIEndpointProvider.API.runs_cancel
        
        var request = prepareRequest(endpoint)
        request.url?.appendPathComponent("/\(thread_id)/runs/\(run_id)/cancel")

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


    /// createThreadRun request to the OpenAI API
    /// - Parameters:
    ///   - assistant_id: The ID of the assistant to use to execute this run.
    ///   - thread: Optional. The ID of the run to cancel
    ///   - model: Optional. The ID of the Model to be used to execute this run. If a value is provided here, it will override the model associated with the assistant. If not, the model associated with the assistant will be used.
    ///   - instructions: Optional. Override the default system message of the assistant. This is useful for modifying the behavior on a per-run basis.
    ///   - tools: Optional. Override the tools the assistant can use for this run. This is useful for modifying the behavior on a per-run basis.
    ///   - metadata Optional. Set of 16 key-value pairs that can be attached to an object. This can be useful for storing additional information about the object in a structured format. Keys can be a maximum of 64 characters long and values can be a maxium of 512 characters long.
    ///   
    ///   - completionHandler: A Run Object.

    public func createThreadRun(assistant_id: String, thread: ThreadRun?, model:String?, instructions: String?, tools: [Tools]?, metadata: [String:String]?, completionHandler: @escaping (Result<OpenAI<UrlResult>, OpenAIError>) -> Void) {
        
        let endpoint = OpenAIEndpointProvider.API.runs_thread_create
        
        let body = ThreadRunRequest(assistant_id: assistant_id, thread: thread, model: model, instructions: instructions, tools: tools, metatdata: metadata)
        
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

    /// retrieveRunStep request to the OpenAI API
    /// - Parameters:
    ///   - thread_id: The ID of the thread to which the run and run step belongs.
    ///   - run_id: The ID of the run to which the run step belongs.
    ///   - step_id: The ID of the run step to retrieve.
    ///
    ///   - completionHandler: A RunStep Object.

    public func retrieveRunStep(thread_id: String, run_id: String, step_id: String, completionHandler: @escaping (Result<OpenAI<UrlResult>, OpenAIError>) -> Void) {
        
        let endpoint = OpenAIEndpointProvider.API.run_step_retrieve
                
        var request = prepareRequest(endpoint)

        request.url?.appendPathComponent("/\(thread_id)/runs/\(run_id)/steps/\(step_id)")
        
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

    /// listRunSteps request to the OpenAI API
    /// - Parameters:
    ///   - thread_id: The ID of the thread to which the run and run step belongs.
    ///   - run_id: The ID of the run to which the run step belongs.
    ///
    ///   - limit: Optional, A limit on the number of objects to be returned. Limit can range between 1 and 100, and the default is 20.
    ///   - order: Optional. Sort order by the created_at timestamp of the objects. asc for ascending order and desc for descending order.
    ///   - after: Optional. A cursor for use in pagination. after is an object ID that defines your place in the list.
    ///   - before: Optional. A cursor for use in pagination. before is an object ID that defines your place in the list.
    ///
    ///   - completionHandler: A list of RunSteps belonging to the a Run

    public func listRunSteps(thread_id: String, run_id: String, limit: Int?, order: String?, after:String?, before:String?, completionHandler: @escaping (Result<OpenAI<UrlResult>, OpenAIError>) -> Void) {
        
        let endpoint = OpenAIEndpointProvider.API.run_step_list
        
        let rlr = RunListRequest(limit: limit, order: order, after: after, before: before)
        
        var queryItems: [URLQueryItem] = []
        
        if let parameters = rlr.toDictionary() {
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

        request.url?.appendPathComponent("/\(thread_id)/runs/\(run_id)/steps")
        
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
