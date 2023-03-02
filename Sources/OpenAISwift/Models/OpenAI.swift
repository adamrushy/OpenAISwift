//
//  Created by Adam Rush - OpenAISwift
//

import Foundation

public protocol Payload: Codable { }

public struct OpenAI<T: Payload>: Codable {
    public let object: String
    public let model: String?
    public let choices: [T]
}

public struct TextResult: Payload {
    public let text: String
}

public struct MessageResult: Payload {
    public let message: ChatMessage
}
