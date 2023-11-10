//
//  Created by Adam Rush - OpenAISwift
//

import Foundation
#if canImport(FoundationNetworking) && canImport(FoundationXML)
import FoundationNetworking
import FoundationXML
#endif

public struct OpenAIEndpointProvider {
    public enum API {
        case assistant_create
        case assistant_retrieve
        case assistant_modify
        case assistant_delete
        case assistant_list
        case audio_speech
        case audio_transcription
        case audio_translation
        case chat
        case completions
        case edits
        case embeddings
        case files_upload
        case files_list
        case files_delete
        case files_retrieve
        case fine_tuning_create
        case fine_tuning_list
        case fine_tuning_cancel
        case fine_tuning_retrieve
        case images
        case image_edits
        case image_variations
        case models_list
        case models_retrieve
        case models_delete
        case moderations
        case thread_create
        case thread_retrieve
        case thread_modify
        case thread_delete
        case messages_create
        case messages_retrieve
        case messages_list
        case messages_modify
        case runs_create
        case runs_retrieve
        case runs_modify
        case runs_list
        case runs_submit
        case runs_cancel
        case runs_thread_create
        case run_step_retrive
        case run_step_list
    }
    
    public enum Source {
        case openAI
        case proxy(path: ((API) -> String), method: ((API) -> String))
    }
    
    public let source: Source
    
    public init(source: OpenAIEndpointProvider.Source) {
        self.source = source
    }
    
    func getPath(api: API) -> String {
        switch source {
        case .openAI:
            switch api {
            case .assistant_create, .assistant_retrieve, .assistant_modify, .assistant_delete, .assistant_list:
                return "/v1/assistants"
            case .audio_speech:
                return "v1/audio/speech"
            case .audio_transcription:
                return "v1/audio/transcriptions"
            case .audio_translation:
                return "v1/audio/speech/translations"
            case .chat:
                return "/v1/chat/completions"
            case .completions:
                return "/v1/completions"
            case .edits:
                return "/v1/edits"
            case .embeddings:
                return "/v1/embeddings"
            case .files_list, .files_delete, .files_upload, .files_retrieve:
                return "v1/files"
            case .fine_tuning_create, .fine_tuning_list, .fine_tuning_cancel, .fine_tuning_retrieve:
                return "v1/fine_tuning/jobs"
            case .images:
                return "/v1/images/generations"
            case .image_edits:
                return "/v1/images/edits"
            case .image_variations:
                return "/v1/images/variations"
            case .models_list, .models_delete, .models_retrieve:
                return "v1/models"
            case .moderations:
                return "/v1/moderations"
            case .thread_create, .thread_delete, .thread_modify, .thread_retrieve, .messages_list, .messages_create, .messages_modify, .messages_retrieve,
                    .runs_create, .runs_retrieve, .runs_modify, .runs_list, .runs_submit, .runs_cancel, .run_step_retrive, .run_step_list:
                return "v1/threads"
            case .runs_thread_create:
                return "v1/threads/runs"
            }
        case let .proxy(path: pathClosure, method: _):
            return pathClosure(api)
        }
    }
    
    func getMethod(api: API) -> String {
        switch source {
        case .openAI:
            switch api {
            case .assistant_delete, .files_delete, .models_delete, .thread_delete:
                return "DELETE"
            case .assistant_retrieve, .assistant_list, .files_retrieve, .files_list, .fine_tuning_list, .fine_tuning_retrieve, .models_list, .models_retrieve, .thread_modify, .thread_retrieve, .messages_retrieve, .messages_list, .runs_retrieve, .runs_list, .run_step_list, .run_step_retrive:
                return "GET"
                
            case .assistant_create, .assistant_modify, .audio_speech, .audio_translation, .audio_transcription, .completions, .edits, .chat, .images, .embeddings, .files_upload, .fine_tuning_create, .fine_tuning_cancel, .moderations, .image_edits, .image_variations, .thread_create, .messages_create, .messages_modify, .runs_create, .runs_modify, .runs_submit, .runs_cancel, .runs_thread_create:
                return "POST"
            }
        case let .proxy(path: _, method: methodClosure):
            return methodClosure(api)
        }
    }
}
