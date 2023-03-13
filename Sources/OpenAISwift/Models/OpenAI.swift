//
//  Created by Adam Rush - OpenAISwift
//

import Foundation

public protocol Payload: Codable { }

public struct OpenAI<T: Payload>: Codable {
    public let object: String
    public let model: String?
    public let choices: [T]
    public let usage: UsageResult
}

public struct TextResult: Payload {
    public let text: String
}

public struct MessageResult: Payload {
    public let message: ChatMessage
}

public struct UsageResult: Payload {
    public var prompt_tokens: Int
    public var completion_tokens: Int
    public var total_tokens: Int
}
