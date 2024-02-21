//
//  File.swift
//  
//
//  Created by Mark Hoath on 16/11/2023.
//

import Foundation

public struct ImageFileID: Codable {
    public let file_id: String
}

public struct ImageFile: Codable {
    public let type: String             //  always = "image_file"
    public let image_file: ImageFileID
}

public struct FileCitation: Codable {
    public let file_id: String
    public let quote: String
}

public struct TextFileCitation: Codable {
    public let type: String             //  always = "file_citation"
    public let text: String
    public let file_citation: FileCitation
    public let start_index: Int
    public let end_index: Int
}

public struct FilePathID: Codable {
    public let file_id: String
}

public struct TextFilePath: Codable {
    public let type: String             //  always = "file_path"
    public let text: String
    public let file_path: FilePathID
    public let start_index: Int
    public let end_index: Int
}

public struct TextFileAnnotations: Codable {
    public let file_citation: FileCitation
    public let file_path: TextFilePath
}

public struct TextFileObject: Codable {
    public let value: String
    public let annotations: [TextFileAnnotations]
}

public struct TextFile: Codable {
    public let type: String             //   always = "text"
    public let text: TextFileObject
}

public struct MessageContent: Codable {
    public let image: ImageFile
    public let text: TextFile
}

public struct MessageObject: Codable {
    public let id: String
    public let object: String       //  always = "thread.message"
    public let created_at: Int
    public let thread_id: String
    public let role: String
    public let content: [MessageContent]
    public let assistant_id: String?
    public let run_id: String?
    public let file_ids: [String]           //  max 10
    public let metadata: [String:String]    //  16 Key - Value Pairs. Key max 64 chats. Value max 512 chars
}

public struct Message: Codable {
    public let role: String
    public let content: String              // always = "thread"
    public let file_ids: [String]?          //  Max 10 File ID's
    public let metadata: [String:String]?   // 16 key-value pairs. Value max 512 chars
    
}

public struct MessageListRequest: Codable {
    public let limit: Int?
    public let order: String?
    public let after: String?
    public let before: String?
}
