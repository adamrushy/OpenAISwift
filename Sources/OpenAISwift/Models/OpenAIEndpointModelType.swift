//
//  OpenAIEndpointModelType.swift
//
//
//  Created by Marco Boerner on 01.09.23.
//

import Foundation

/// Currently available and recommended models including some, but not all, legacy models
/// https://platform.openai.com/docs/models/model-endpoint-compatibility
public struct OpenAIEndpointModelType {

    public enum AudioTranscriptions: String, Codable {
        /// Whisper v2-large model (under the name whisper1) is a general-purpose speech recognition model. It is trained on a large dataset of diverse audio and is also a multi-task model that can perform multilingual speech recognition as well as speech translation and language identification
        case whisper1 = "whisper-1"
    }

    public enum AudioTranslations: String, Codable {
        /// Whisper v2-large model (under the name whisper1) is a general-purpose speech recognition model. It is trained on a large dataset of diverse audio and is also a multi-task model that can perform multilingual speech recognition as well as speech translation and language identification
        case whisper1 = "whisper-1"
    }

    public enum ChatCompletions: String, Codable {
        /// More capable than any GPT-3.5 model, able to do more complex tasks, and optimized for chat. Will be updated with our latest model iteration 2 weeks after it is released. - 8,192 tokens
        case gpt4 = "gpt-4"

        /// Snapshot of gpt-4 from June 13th 2023 with function calling data. Unlike gpt-4, this model will not receive updates, and will be deprecated 3 months after a new version is released. - 8,192 tokens
        case gpt40613 = "gpt-4-0613"

        /// Same capabilities as the standard gpt-4 mode but with 4x the context length. Will be updated with our latest model iteration. - 32,768 tokens
        case gpt432k = "gpt-4-32k"

        /// Snapshot of gpt-4-32 from June 13th 2023. Unlike gpt-4-32k, this model will not receive updates, and will be deprecated 3 months after a new version is released. - 32,768 tokens
        case gpt432k0613 = "gpt-4-32k-0613"

        /// A faster version of GPT-3.5 with the same capabilities. Will be updated with our latest model iteration. - 4,096 tokens
        case gpt35Turbo = "gpt-3.5-turbo"

        /// Snapshot of gpt-3.5-turbo from June 13th 2023. Unlike gpt-3.5-turbo, this model will not receive updates, and will be deprecated 3 months after a new version is released. - 4,096 tokens
        case gpt35Turbo0613 = "gpt-3.5-turbo-0613"

        /// A faster version of GPT-3.5 with the same capabilities and 4x the context length. Will be updated with our latest model iteration. - 16,384 tokens
        case gpt35Turbo16k = "gpt-3.5-turbo-16k"

        /// Snapshot of gpt-3.5-turbo-16k from June 13th 2023. Unlike gpt-3.5-turbo-16k, this model will not receive updates, and will be deprecated 3 months after a new version is released. - 16,384 tokens
        case gpt35Turbo16k0613 = "gpt-3.5-turbo-16k-0613"
    }

    public enum LegacyCompletions: String, Codable {
        /// Can do any language task with better quality, longer output, and consistent instruction-following than the curie, babbage, or ada models. Also supports some additional features such as inserting text. - 4,097 tokens
        case textDavinci003 = "text-davinci-003"

        /// Similar capabilities to text-davinci-003 but trained with supervised fine-tuning instead of reinforcement learning - 4,097 tokens
        case textDavinci002 = "text-davinci-002"

        /// Optimized for code-completion tasks - 8,001 tokens
        case textDavinci001 = "text-davinci-001"

        /// Very capable, faster and lower cost than Davinci. - 2,049 tokens
        case textCurie001 = "text-curie-001"

        /// Capable of straightforward tasks, very fast, and lower cost. - 2,049 tokens
        case textBabbage001 = "text-babbage-001"

        /// Capable of very simple tasks, usually the fastest model in the GPT-3 series, and lowest cost. - 2,049 tokens
        case textAda001 = "text-ada-001"

        /// Most capable GPT-3 model. Can do any task the other models can do, often with higher quality. - 2,049 tokens
        case davinci = "davinci"

        /// Very capable, but faster and lower cost than Davinci. - 2,049 tokens
        case curie = "curie"

        /// Capable of straightforward tasks, very fast, and lower cost. - 2,049 tokens
        case babbage = "babbage"

        /// Capable of very simple tasks, usually the fastest model in the GPT-3 series, and lowest cost. - 2,049 tokens
        case ada = "ada"
    }

    public enum Embeddings: String, Codable {

        /// The new model, text-embedding-ada-002, replaces five separate models for text search, text similarity, and code search, and outperforms previous most capable model, Davinci, at most tasks, while being priced 99.8% lower.
        case textEmbeddingAda002 = "text-embedding-ada-002"
    }

    public enum FineTuningJobs: String, Codable {

        /// (experimental — eligible users will be presented with an option to request access in the fine-tuning UI)
        case gpt4_0613 = "gpt-4-0613"

        /// Most capable GPT-3.5 RECOMMENDED
        case gpt35Turbo1106 = "gpt-3.5-turbo-1106"

        ///  use 1106 for more updated model
        case gpt35Turbo0613 = "gpt-3.5-turbo-0613"

        /// Replacement for the GPT-3 ada and babbage base models. - 16,384 tokens
        case babbage002 = "babbage-002"

        /// Replacement for the GPT-3 curie and davinci base models. - 16,384 tokens
        case davinci002 = "davinci-002"
    }

    public enum FineTunes: String, Codable {

        /// Most capable GPT-3 model. Can do any task the other models can do, often with higher quality. - 2,049 tokens
        case davinci = "davinci"

        /// Very capable, but faster and lower cost than Davinci. - 2,049 tokens
        case curie = "curie"

        /// Capable of straightforward tasks, very fast, and lower cost. - 2,049 tokens
        case babbage = "babbage"

        /// Capable of very simple tasks, usually the fastest model in the GPT-3 series, and lowest cost. - 2,049 tokens
        case ada = "ada"
    }

    public enum Moderations: String, Codable {

        /// Most capable moderation model. Accuracy will be slightly higher than the stable model.
        case textModerationStable = "text-moderation-stable"

        /// Almost as capable as the latest model, but slightly older.
        case textModerationLatest = "text-moderation-latest"
    }
}
