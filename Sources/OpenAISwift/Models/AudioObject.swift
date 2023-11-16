//
//  File.swift
//  
//
//  Created by Mark Hoath on 14/11/2023.
//

import Foundation

public enum Voice: String, Codable {
    case alloy, echo, fable, onyx, nova, shimmer
}

public enum AudioResponseFormat: String, Codable {
    case mp3, opus, aac, flac
}

public enum TranscriptionResponseFormat: String, Codable {
    case json, text, srt, verbose_json, vtt
}

public struct Audio: Encodable {
    public let model: String
    public let input: String
    public let voice: Voice
    public let response_format: AudioResponseFormat?
    public let speed: Double?
}

public struct Transcription: Encodable {
    public let file: String
    public let model: String
    public let language: String?
    public let prompt: String?
    public let response_format: TranscriptionResponseFormat?
    public let temperature: Double?
    
}

public struct Translation: Encodable {
    public let file: String
    public let model: String
    public let prompt: String?
    public let response_format: TranscriptionResponseFormat?
    public let temperature: Double?
}

