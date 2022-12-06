//
//  File.swift
//  
//
//  Created by Adam Rush on 06/12/2022.
//

import Foundation

enum Endpoint {
    case completions
}

extension Endpoint {
    var path: String {
        switch self {
        case .completions:
            return "/v1/completions"
        }
    }
    
    var method: String {
        switch self {
        case .completions:
            return "POST"
        }
    }
    
    func baseURL() -> String {
        switch self {
        case .completions:
            return "https://api.openai.com"
        }
    }
}
