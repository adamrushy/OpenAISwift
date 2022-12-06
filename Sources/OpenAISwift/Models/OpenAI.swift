//
//  OpenAI.swift
//  
//
//  Created by Adam Rush on 06/12/2022.
//

import Foundation

public struct OpenAI: Codable {
    public let object: String
    public let model: String
    public let choices: [Choice]
}

public struct Choice: Codable {
    public let text: String
}
