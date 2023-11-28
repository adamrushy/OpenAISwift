//
//  URLSessionRequestHandler.swift
//  LumenateApp
//
//  Created by Simon Mitchell on 28/11/2023.
//

import Foundation

public final class URLSessionRequestHandler: NSObject, OpenAIRequestHandler {
    
    let baseURL: String
    
    let endpointProvider: OpenAIEndpointProvider
    
    let session: URLSession
    
    let authorizeRequest: (inout URLRequest) -> Void
    
    var onEventReceived: ((Result<OpenAI<StreamMessageResult>, OpenAIError>) -> Void)?
    
    var onComplete: (() -> Void)?
    
    private lazy var streamingSession: URLSession = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
    
    private var streamingTask: URLSessionDataTask?
    
    /// Default memberwise initialiser
    /// - Parameters:
    ///   - baseURL: The base url to load data from
    ///   - endpointPrivider: An endpoint provider for generating full urls for each request
    ///   - session: The session to use for network requests
    ///   - authorizeRequest: A closure to authenticate a specific `URLRequest`
    public init(baseURL: String, endpointPrivider: OpenAIEndpointProvider, session: URLSession, authorizeRequest: @escaping (inout URLRequest) -> Void) {
        self.session = session
        self.endpointProvider = endpointPrivider
        self.authorizeRequest = authorizeRequest
        self.baseURL = baseURL
    }
    
    // MARK: Protocol Conformance
    
    public func makeRequest<BodyType>(_ endpoint: OpenAIEndpointProvider.API, body: BodyType, completionHandler: @escaping (Result<Data, Error>) -> Void) where BodyType : Encodable {
        let request = prepareRequest(endpoint, body: body)
        makeRequest(request: request, completionHandler: completionHandler)
    }
    
    public func streamRequest<BodyType>(_ endpoint: OpenAIEndpointProvider.API, body: BodyType, eventReceived: ((Result<OpenAI<StreamMessageResult>, OpenAIError>) -> Void)?, completion: (() -> Void)?) where BodyType : Encodable {
        
        let request = prepareRequest(endpoint, body: body)
        self.onEventReceived = eventReceived
        self.onComplete = completion
        connect(with: request)
    }
    
    private func makeRequest(request: URLRequest, completionHandler: @escaping (Result<Data, Error>) -> Void) {
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completionHandler(.failure(error))
            } else if let data = data {
                completionHandler(.success(data))
            }
        }
        
        task.resume()
    }
    
    private func prepareRequest<BodyType: Encodable>(_ endpoint: OpenAIEndpointProvider.API, body: BodyType) -> URLRequest {
        var urlComponents = URLComponents(url: URL(string: baseURL)!, resolvingAgainstBaseURL: true)
        urlComponents?.path = endpointProvider.getPath(api: endpoint)
        var request = URLRequest(url: urlComponents!.url!)
        request.httpMethod = endpointProvider.getMethod(api: endpoint)
        
        authorizeRequest(&request)
        
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(body) {
            request.httpBody = encoded
        }
        
        return request
    }
    
    private func connect(with request: URLRequest) {
        streamingTask = session.dataTask(with: request)
        streamingTask?.resume()
    }
    
    fileprivate func disconnect() {
        streamingTask?.cancel()
    }

    fileprivate func processEvent(_ eventData: Data) {
        do {
            let res = try JSONDecoder().decode(OpenAI<StreamMessageResult>.self, from: eventData)
            onEventReceived?(.success(res))
        } catch {
            onEventReceived?(.failure(.decodingError(error: error)))
        }
    }
}

extension URLSessionRequestHandler: URLSessionDataDelegate {
    /// It will be called several times, each time could return one chunk of data or multiple chunk of data
    /// The JSON look liks this:
    /// `data: {"id":"chatcmpl-6yVTvD6UAXsE9uG2SmW4Tc2iuFnnT","object":"chat.completion.chunk","created":1679878715,"model":"gpt-3.5-turbo-0301","choices":[{"delta":{"role":"assistant"},"index":0,"finish_reason":null}]}`
    /// `data: {"id":"chatcmpl-6yVTvD6UAXsE9uG2SmW4Tc2iuFnnT","object":"chat.completion.chunk","created":1679878715,"model":"gpt-3.5-turbo-0301","choices":[{"delta":{"content":"Once"},"index":0,"finish_reason":null}]}`
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        if let eventString = String(data: data, encoding: .utf8) {
            let lines = eventString.split(separator: "\n")
            for line in lines {
                if line.hasPrefix("data:") && line != "data: [DONE]" {
                    if let eventData = String(line.dropFirst(5)).data(using: .utf8) {
                        processEvent(eventData)
                    } else {
                        disconnect()
                    }
                }
            }
        }
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            onEventReceived?(.failure(.genericError(error: error)))
        } else {
            onComplete?()
        }
    }
}

public extension Config {
    
    static func makeDefaultOpenAI(apiKey: String) -> URLSessionRequestHandler {
        return URLSessionRequestHandler(baseURL: "https://api.openai.com",
                                        endpointPrivider: OpenAIEndpointProvider(source: .openAI),
                                        session: .shared,
                                        authorizeRequest: { request in
            request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        })
    }
}
