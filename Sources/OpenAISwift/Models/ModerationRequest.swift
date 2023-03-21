//
//  ModerationRequest.swift
//

import Foundation

/// A moderation request.
public struct ModerationRequest: Codable {
    /// The input string to moderate.
    let input: String
    
    /// The moderation model to use.
    let model: String
}
