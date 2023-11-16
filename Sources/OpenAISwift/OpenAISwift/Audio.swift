//
//  Audio.swift
//  
//
//  Created by Mark Hoath on 14/11/2023.
//

import Foundation

// Completely Untested !!!!
// Needs to have ASYNC version for Audio Play in Real Time.

extension OpenAISwift {
    
    /// Create Speech request to the OpenAI API
    /// - Parameters:
    ///   - model: One of the available TTS models: tts-1 or tts-1-hd
    ///   - input: The text to generate audio for. The maximum length is 4096 characters.
    ///   - voice: The voice to use when generating the audio. Supported voices are alloy, echo, fable, onyx, nova, and shimmer
    ///   - response_format: TThe format to audio in. Supported formats are mp3, opus, aac, and flac.
    ///   - speed: The speed of the generated audio. Select a value from 0.25 to 4.0. 1.0 is the default.

    ///   - completionHandler: Returns audio file content.
    
    // FIX needs to be streaming.
    
    public func createSpeech(model: OpenAIModelType.TTS, input: String, voice: Voice, response_format: AudioResponseFormat? = .mp3, speed: Double?=1.0, completionHandler: @escaping (Result<OpenAI<UrlResult>, OpenAIError>) -> Void) {
        
        let endpoint = OpenAIEndpointProvider.API.audio_speech
        let body = Audio(model: model.rawValue, input: input, voice: voice, response_format: response_format, speed: speed)
        let request = prepareRequest(endpoint, body: body, queryItems: nil)

        makeRequest(request: request) { result in
            
            switch result {
                case .success(let success):
                    do {
                        let res = try JSONDecoder().decode(OpenAI<UrlResult>.self, from: success)
                        completionHandler(.success(res))
                    } catch {
                        completionHandler(.failure(.decodingError(error: error)))
                    }
                case .failure(let failure):
                    completionHandler(.failure(.genericError(error: failure)))
                }
        }
    }
    
    /// Create Transcription request to the OpenAI API
    /// - Parameters:
    ///   - file: URL for an Audio file. The audio file object (not file name) to transcribe, in one of these formats: flac, mp3, mp4, mpeg, mpga, m4a, ogg, wav, or webm.
    ///   - model: The Model to use. Only whisper-1 is currently available.
    ///   - language: The language of the input audio. Supplying the input language in ISO-639-1 format will improve accuracy and latency.
    ///   - prompt: An optional text to guide the model's style or continue a previous audio segment. The prompt should match the audio language.
    ///   - response_format: The format of the transcript output, in one of these options: json, text, srt, verbose_json, or vtt.
    ///   - temperature: The sampling temperature, between 0 and 1. Higher values like 0.8 will make the output more random, while lower values like 0.2 will make it more focused and deterministic. If set to 0, the model will use log probability to automatically increase the temperature until certain thresholds are hit.
    ///   - completionHandler: Returns the transcribed text {"text":"Hello There"}

    public func createTranscription(file: URL, model: OpenAIEndpointModelType.AudioTranscriptions, language: String?, prompt: String?, response_format: TranscriptionResponseFormat? = .json, temperature: Double?=0.0, completionHandler: @escaping (Result<OpenAI<UrlResult>, OpenAIError>) -> Void) {
        
        let endpoint = OpenAIEndpointProvider.API.audio_transcription
        let body = Transcription(file: file.absoluteString, model: model.rawValue, language: language, prompt: prompt, response_format: response_format, temperature: temperature)
        let request = prepareRequest(endpoint, body: body, queryItems: nil)

        makeRequest(request: request) { result in
            
            switch result {
                case .success(let success):
                    do {
                        let res = try JSONDecoder().decode(OpenAI<UrlResult>.self, from: success)
                        completionHandler(.success(res))
                    } catch {
                        completionHandler(.failure(.decodingError(error: error)))
                    }
                case .failure(let failure):
                    completionHandler(.failure(.genericError(error: failure)))
                }
        }
    }
    
    /// Create Translation request to the OpenAI API - Translates into English
    /// - Parameters:
    ///   - file: URL for an Audio file. The audio file object (not file name) to transcribe, in one of these formats: flac, mp3, mp4, mpeg, mpga, m4a, ogg, wav, or webm.
    ///   - model: The Model to use. Only whisper-1 is currently available.
    ///   - prompt: An optional text to guide the model's style or continue a previous audio segment. The prompt should match the audio language.
    ///   - response_format: The format of the transcript output, in one of these options: json, text, srt, verbose_json, or vtt.
    ///   - temperature: The sampling temperature, between 0 and 1. Higher values like 0.8 will make the output more random, while lower values like 0.2 will make it more focused and deterministic. If set to 0, the model will use log probability to automatically increase the temperature until certain thresholds are hit.

    ///   - completionHandler: Returns the translated text {"text":"Hello There"}

    
    public func createTranslation(file: URL, model: OpenAIEndpointModelType.AudioTranslations, prompt: String?, response_format: TranscriptionResponseFormat? = .json, temperature: Double?=0.0, completionHandler: @escaping (Result<OpenAI<UrlResult>, OpenAIError>) -> Void) {
        
        let endpoint = OpenAIEndpointProvider.API.audio_translation
        let body = Translation(file: file.absoluteString, model: model.rawValue,  prompt: prompt, response_format: response_format, temperature: temperature)
        let request = prepareRequest(endpoint, body: body, queryItems: nil)

        makeRequest(request: request) { result in
            
            switch result {
                case .success(let success):
                    do {
                        let res = try JSONDecoder().decode(OpenAI<UrlResult>.self, from: success)
                        completionHandler(.success(res))
                    } catch {
                        completionHandler(.failure(.decodingError(error: error)))
                    }
                case .failure(let failure):
                    completionHandler(.failure(.genericError(error: failure)))
                }
        }
    }
    

}
