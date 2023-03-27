//
//  Created by Adam Rush - OpenAISwift
//

import Foundation

enum Endpoint {
    case completions
    case edits
    case chat
    case images
    case moderations
    
    var path: String {
        switch self {
        case .completions:
            return "/v1/completions"
        case .edits:
            return "/v1/edits"
        case .chat:
            return "/v1/chat/completions"
        case .images:
            return "/v1/images/generations"
        case .moderations:
            return "/v1/moderations"
        }
    }
    
    var method: String {
        switch self {
        case .completions, .edits, .chat, .images, .moderations:
            return "POST"
        }
    }
    
    func baseURL() -> String {
        switch self {
        case .completions, .edits, .chat, .images, .moderations:
        return "https://api.openai.com"
        }
    }
}
