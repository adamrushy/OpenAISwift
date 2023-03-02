//
//  Created by Adam Rush - OpenAISwift
//

import Foundation

enum Endpoint {
    case chat
    case completions
    case edits
}

extension Endpoint {
    var path: String {
        switch self {
        case .chat:
            return "/v1/chat/completions"
        case .completions:
            return "/v1/completions"
        case .edits:
            return "/v1/edits"
        }
    }
    
    var method: String {
        switch self {
        case .chat, .completions, .edits:
            return "POST"
        }
    }
    
    func baseURL() -> String {
        switch self {
        case .chat, .completions, .edits:
            return "https://api.openai.com"
        }
    }
}
