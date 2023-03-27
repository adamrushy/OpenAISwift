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
        /// A moderation result's categories.
        public struct CategoryResults: Codable {
            /// The hate category.
            public let hate: Bool
            
            /// The hate/threatening category.
            public let hateThreatening: Bool
            
            /// The self-harm category.
            public let selfHarm: Bool
            
            /// The sexual category.
            public let sexual: Bool
            
            /// The sexual/minors category.
            public let sexualMinors: Bool
            
            /// The violence category.
            public let violence: Bool
            
            /// The violence/graphic category.
            public let violenceGraphic: Bool
            
            enum CodingKeys: String, CodingKey {
                case hate
                case hateThreatening = "hate/threatening"
                case selfHarm = "self-harm"
                case sexual
                case sexualMinors = "sexual/minors"
                case violence
                case violenceGraphic = "violence/graphic"
            }
        }

        /// A moderation result's category scores.
        public struct CategoryScores: Codable {
            /// The hate score.
            public let hate: Double
            
            /// The hate/threatening score.
            public let hateThreatening: Double
            
            /// The self-harm score.
            public let selfHarm: Double
            
            /// The sexual score.
            public let sexual: Double
            
            /// The sexual/minors score.
            public let sexualMinors: Double
            
            /// The violence score.
            public let violence: Double
            
            /// The violence/graphic score.
            public let violenceGraphic: Double
            
            enum CodingKeys: String, CodingKey {
                case hate
                case hateThreatening = "hate/threatening"
                case selfHarm = "self-harm"
                case sexual
                case sexualMinors = "sexual/minors"
                case violence
                case violenceGraphic = "violence/graphic"
            }
        }
        
        /// A mapping of flagged categories.
        public let categories: CategoryResults
        
        /// The moderation score for each category.
        public let categoryScores: CategoryScores
        
        /// Whether the overall input was flagged.
        public let isFlagged: Bool
        
        enum CodingKeys: String, CodingKey {
            case categories
            case categoryScores = "category_scores"
            case isFlagged = "flagged"
        }
    }
}