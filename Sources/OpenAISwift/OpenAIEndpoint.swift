//
//  Created by Adam Rush - OpenAISwift
//

import Foundation

enum Endpoint {
    case completions
    case edits
    case chat
    case images
    case embeddings
}

extension Endpoint {
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
            case .embeddings:
            return "/v1/embeddings"
        }
    }
    
    var method: String {
        switch self {
            case .completions, .edits, .chat, .images, .embeddings:
            return "POST"
        }
    }
    
    func baseURL() -> String {
        switch self {
            case .completions, .edits, .chat, .images, .embeddings:
            return "https://api.openai.com"
        }
    }
}
