//
//  File.swift
//  
//
//  Created by Bogdan Farca on 02.03.2023.
//

import Foundation

public enum ChatRole: String, Codable {
    case system, user, assistant
}

public struct ChatMessage: Codable {
    public let role: ChatRole
    public let content: String
    
    public init(role: ChatRole, content: String) {
        self.role = role
        self.content = content
    }
}

public struct ChatConversation: Encodable {
    let messages: [ChatMessage]
    let model: String
    let maxTokens: Int?

    enum CodingKeys: String, CodingKey {
        case messages
        case model
        case maxTokens = "max_tokens"
    }

}
