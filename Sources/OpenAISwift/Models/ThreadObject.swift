//
//  File.swift
//  
//
//  Created by Mark Hoath on 16/11/2023.
//

import Foundation

public struct ThreadObject: Codable {
    public let id: String
    public let object:String        //      always = "thread"
    public let created_at: Int
    public let metadata: [String: String]   //  Max 16 array of Key/value value max is 512 bytes
}
