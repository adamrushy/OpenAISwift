//
//  OpenAIRequestHandler.swift
//  LumenateApp
//
//  Created by Simon Mitchell on 28/11/2023.
//

import Foundation

public protocol OpenAIRequestHandler {
    
    /// Function which performs the request as required from the user.
    /// - Note: However the request is made, it must do a few things
    /// 1. Call `completionHandler` with any errors or response data
    /// 2. Data returned must be decodable to the model types defined in this library
    /// - Parameters:
    ///   - endpoint: The endpoint to make a request to
    ///   - body: The body of the request to make
    ///   - completionHandler: A closure to be called once the request has completed
    func makeRequest<BodyType: Encodable>(_ endpoint: OpenAIEndpointProvider.API, body: BodyType, completionHandler: @escaping (Result<Data, Error>) -> Void)
    
    /// Function which streams the request as required by the user.
    /// - Note: Only "chat" api is streamable for now, so this always has return type of `StreamMessageResult`
    /// - Parameters:
    ///   - endpoint: The endpoint to stream the request from. Note: currently this is only for "chat" endpoint
    ///   - body: The body of the request to make
    ///   - eventReceived: Called Multiple times, returns an OpenAI Data Model
    ///   - completion: Triggers when sever complete sending the message
    func streamRequest<BodyType: Encodable>(
        _ endpoint: OpenAIEndpointProvider.API,
        body: BodyType,
        eventReceived: ((Result<OpenAI<StreamMessageResult>, OpenAIError>) -> Void)?,
        completion: (() -> Void)?
    )
}
