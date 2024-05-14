//
//  File.swift
//  
//
//  Created by Mark Hoath on 15/11/2023.
//

import Foundation

public struct ModelObject: Codable {
    
    public let id: String
    public let created: Int
    public let object: String
    public let owned_by: String
}
