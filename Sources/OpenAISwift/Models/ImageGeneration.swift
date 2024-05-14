//
//  ImageGeneration.swift
//  
//
//  Created by Arjun Dureja on 2023-03-11.
//

import Foundation

struct ImageGeneration: Encodable {
    let prompt: String
    let n: Int
    let size: ImageSize
    let user: String?
}

struct ImageEdit: Encodable {
    let image: Data
    let mask: Data?
    let prompt: String
    let n: Int
    let size: ImageSize
    let user: String?
}

struct ImageVariations: Encodable {
    let image: Data
    let n: Int
    let size: ImageSize
    let user: String?
}

public enum ImageSize: String, Codable {
    case size1024 = "1024x1024"
    case size512 = "512x512"
    case size256 = "256x256"
}
