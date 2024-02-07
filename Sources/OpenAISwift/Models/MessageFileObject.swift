//
//  File.swift
//  
//
//  Created by Mark Hoath on 16/11/2023.
//

import Foundation

public struct MessageFileObject: Codable {
    public let id: String
    public let object: String
    public let created_at: Int
    public let message_id: String
}
