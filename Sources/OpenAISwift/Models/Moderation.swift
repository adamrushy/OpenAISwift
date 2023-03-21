//
//  ModerationRequest.swift
//

import Foundation

public enum Moderation {
    /// A moderation request.
    struct Request: Codable {
        /// The input string to moderate.
        let input: String
        
        /// The moderation model to use.
        let model: String
    }
    
    
    /// A moderation result.
    public struct Result: Payload {
        /// A moderation category.
        public enum Category: String, Codable {
            case hate
            case hateThreatening = "hate/threatening"
            case selfHarm = "self-harm"
            case sexual = "sexual"
            case sexualMinors = "sexual/minors"
            case violence
            case violenceGraphic = "violence/graphic"
        }
        
        /// A mapping of flagged categories.
        public let categories: [Category: Bool]
        
        /// The moderation score for each category.
        public let categoryScores: [Category: Double]
        
        /// Whether the overall input was flagged.
        public let isFlagged: Bool
        
        enum CodingKeys: String, CodingKey {
            case categories
            case categoryScores = "category_scores"
            case isFlagged = "flagged"
        }
    }
}
