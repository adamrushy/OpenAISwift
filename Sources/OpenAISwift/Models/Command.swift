//
//  Created by Adam Rush - OpenAISwift
//

import Foundation

struct Command: Encodable {
    let prompt: String
    let model: String
    let maxTokens: Int
    
    enum CodingKeys: String, CodingKey {
        case prompt
        case model
        case maxTokens = "max_tokens"
    }
}
