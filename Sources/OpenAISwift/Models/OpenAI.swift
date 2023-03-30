//
//  Created by Adam Rush - OpenAISwift
//

import Foundation

public protocol Payload: Codable, Equatable { }

public struct OpenAI<T: Payload>: Codable, Equatable {
    public let object: String?
    public let model: String?
    public let choices: [T]?
    public let usage: UsageResult?
    public let data: [T]?
}

internal extension OpenAI {
    var isValid: Bool {
        object != nil && model != nil && choices != nil && usage != nil && data != nil
    }
}

public struct TextResult: Payload, Equatable {
    public let text: String
}

public struct MessageResult: Payload {
    public let message: ChatMessage
}

public struct UsageResult: Codable, Equatable {
    public let promptTokens: Int
    public let completionTokens: Int
    public let totalTokens: Int

    enum CodingKeys: String, CodingKey {
        case promptTokens = "prompt_tokens"
        case completionTokens = "completion_tokens"
        case totalTokens = "total_tokens"
    }
}

public struct UrlResult: Payload {
    public let url: String
}
