//
//  ServerSentEventsHandler.swift
//  
//
//  Created by Vic on 2023-03-25.
//

import Foundation

class ServerSentEventsHandler: NSObject {
    
    var onEventReceived: ((Result<OpenAI<StreamMessageResult>, OpenAIError>) -> Void)?
    var onComplete: (() -> Void)?
    
    private lazy var session: URLSession = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
    private var task: URLSessionDataTask?
       
    func connect(with request: URLRequest) {
        task = session.dataTask(with: request)
        task?.resume()
    }
    
    func disconnect() {
        task?.cancel()
    }

    func processEvent(_ eventData: Data) {
        do {
            let res = try JSONDecoder().decode(OpenAI<StreamMessageResult>.self, from: eventData)
            onEventReceived?(.success(res))
        } catch {
            onEventReceived?(.failure(.decodingError(error: error)))
        }
    }
}

extension ServerSentEventsHandler: URLSessionDataDelegate {
    
    /// It will be called several times, each time could return one chunk of data or multiple chunk of data
    /// The JSON look liks this:
    /// `data: {"id":"chatcmpl-6yVTvD6UAXsE9uG2SmW4Tc2iuFnnT","object":"chat.completion.chunk","created":1679878715,"model":"gpt-3.5-turbo-0301","choices":[{"delta":{"role":"assistant"},"index":0,"finish_reason":null}]}`
    /// `data: {"id":"chatcmpl-6yVTvD6UAXsE9uG2SmW4Tc2iuFnnT","object":"chat.completion.chunk","created":1679878715,"model":"gpt-3.5-turbo-0301","choices":[{"delta":{"content":"Once"},"index":0,"finish_reason":null}]}`
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
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
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            onEventReceived?(.failure(.genericError(error: error)))
        } else {
            onComplete?()
        }
    }
}
