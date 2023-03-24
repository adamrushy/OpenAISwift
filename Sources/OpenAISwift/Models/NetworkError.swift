//
//  File.swift
//  
//
//  Created by Rob Jonson on 24/03/2023.
//

import Foundation

public enum OAISNetworkError: Error {
    case badResponse(code: Int, response: String?)

    var localizedDescription: String {
        switch self {
        case .badResponse(let code, let contents):
            if let contents {
                return "Networking error. Response Code: \(code), Message\n\(contents)"
            } else {
                return "Networking error. Response Code: \(code)"
            }
        }
    }
}
