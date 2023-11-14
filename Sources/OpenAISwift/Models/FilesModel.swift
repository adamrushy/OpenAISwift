//
//  File.swift
//  
//
//  Created by Mark Hoath on 14/11/2023.
//

import Foundation


public enum FilePurpose: String, Codable {
    case fine_tune = "fine-tune", fine_tune_results = "fine-tune-results", assistants, assistants_output = "assistants-output"
}

public struct FilesResquest: Codable {
    public let purpose: String?
}

public struct FileUploadResquest: Codable {
    public let file: Data
    public let purpose: String
}

public struct FilesModel: Codable {
    public var id: String
    public var bytes: Int
    public var created_at: Int
    public var filename: String
    public var object: String = "file"
    public var purpose: FilePurpose?
}
