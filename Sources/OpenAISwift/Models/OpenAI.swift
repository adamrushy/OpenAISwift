//
//  Created by Adam Rush - OpenAISwift
//

import Foundation

public protocol Payload: Codable { }

public struct OpenAI<T: Payload>: Codable {
    public let object: String?
    public let model: String?
    public let choices: [T]?
    public let usage: UsageResult?
    public let data: [T]?
}

public struct TextResult: Payload {
    public let text: String
}

public struct MessageResult: Payload {
    public let message: ChatMessage
}

public struct ModerationResult: Payload {
    public enum Category: String, Codable {
        case hate
        case hateThreatening = "hate/threatening"
        case selfHarm = "self-harm"
        case sexual = "sexual"
        case sexualMinors = "sexual/minors"
        case violence
        case violenceGraphic = "violence/graphic"
    }
    
    public let categories: [Category: Bool]
    public let categoryScores: [Category: Double]
    public let isFlagged: Bool
    
    enum CodingKeys: String, CodingKey {
        case categories
        case categoryScores = "category_scores"
        case isFlagged = "flagged"
    }
}

public struct UsageResult: Codable {
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
