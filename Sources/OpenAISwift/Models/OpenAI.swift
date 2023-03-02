//
//  Created by Adam Rush - OpenAISwift
//

import Foundation

public struct CompletionResponse: Codable {
    public let object: String
    public let model: String
    public let choices: [CompletionChoice]
}

public struct CompletionChoice: Codable {
    public let text: String
}

public struct ChatResponse: Codable {
    public let object: String
    public let model: String
    public let choices: [ChatChoice]
}

public struct ChatChoice: Codable {
    public let message: Message
}

public struct Message: Codable {
    public let role: String
    public let content: String
    
    public init(role: String, content: String) {
        self.role = role
        self.content = content
    }
}
