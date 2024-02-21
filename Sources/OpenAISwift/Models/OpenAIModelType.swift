//
//  OpenAIModelType.swift
//  
//
//  Created by Yash Shah on 06/12/2022.
//

import Foundation

/// The type of model used to generate the output
public enum OpenAIModelType {
    /// ``GPT3`` Family of Models
    case gpt3(GPT3)
    
    /// ``Codex`` Family of Models
    case codex(Codex)
    
    /// ``Feature`` Family of Models
    case feature(Feature)
    
    /// ``Chat`` Family of Models
    case chat(Chat)
    
    /// ``GPT4`` Family of Models
    case gpt4(GPT4)
    
    /// ``Embedding`` Family of Models
    case embedding(Embedding)
    
    /// ``Moderation`` Family of Models
    case moderation(Moderation)
    
    /// Other Custom Models
    case other(String)
    
    public var modelName: String {
        switch self {
        case .gpt4(let model): return model.rawValue
        case .gpt3(let model): return model.rawValue
        case .codex(let model): return model.rawValue
        case .feature(let model): return model.rawValue
        case .chat(let model): return model.rawValue
        case .embedding(let model): return model.rawValue
        case .moderation(let model): return model.rawValue
        case .other(let modelName): return modelName
        }
    }
    
    /// A set of models that can understand and generate natural language
    ///
    /// [GPT-3 Models OpenAI API Docs](https://beta.openai.com/docs/models/gpt-3)
    public enum GPT3: String {
        
        /// Most capable GPT-3 model. Can do any task the other models can do, often with higher quality, longer output and better instruction-following. Also supports inserting completions within text.
        ///
        /// > Model Name: text-davinci-003
        case davinci = "text-davinci-003"
        
        /// Very capable, but faster and lower cost than GPT3 ``davinci``.
        ///
        /// > Model Name: text-curie-001
        case curie = "text-curie-001"
        
        /// Capable of straightforward tasks, very fast, and lower cost.
        ///
        /// > Model Name: text-babbage-001
        case babbage = "text-babbage-001"
        
        /// Capable of very simple tasks, usually the fastest model in the GPT-3 series, and lowest cost.
        ///
        /// > Model Name: text-ada-001
        case ada = "text-ada-001"
    }
    
    /// A set of models that can understand and generate code, including translating natural language to code
    ///
    /// [Codex Models OpenAI API Docs](https://beta.openai.com/docs/models/codex)
    ///
    ///  >  Limited Beta
    public enum Codex: String {
        /// Most capable Codex model. Particularly good at translating natural language to code. In addition to completing code, also supports inserting completions within code.
        ///
        /// > Model Name: code-davinci-002
        case davinci = "code-davinci-002"
        
        /// Almost as capable as ``davinci`` Codex, but slightly faster. This speed advantage may make it preferable for real-time applications.
        ///
        /// > Model Name: code-cushman-001
        case cushman = "code-cushman-001"
    }
    
    
    /// A set of models that are feature specific.
    ///
    ///  For example using the Edits endpoint requires a specific data model
    ///
    ///  You can read the [API Docs](https://beta.openai.com/docs/guides/completion/editing-text)
    public enum Feature: String {
        
        /// > Model Name: text-davinci-edit-001
        case davinci = "text-davinci-edit-001"
    }
    
    /// A set of models for the new chat completions
    ///  You can read the [API Docs](https://platform.openai.com/docs/api-reference/chat/create)
    public enum Chat: String {
        
        /// Most capable GPT-3.5 model and optimized for chat at 1/10th the cost of text-davinci-003. Will be updated with our latest model iteration.
        /// > Model Name: gpt-3.5-turbo
        case chatgpt = "gpt-3.5-turbo"
        
        /// Snapshot of gpt-3.5-turbo from March 1st 2023. Unlike gpt-3.5-turbo, this model will not receive updates, and will only be supported for a three month period ending on June 1st 2023.
        /// > Model Name: gpt-3.5-turbo-0301
        case chatgpt0301 = "gpt-3.5-turbo-0301"
    }
    
    /// A set of models for the new GPT4 completions
    ///  Please note that you need to request access first - waitlist: https://openai.com/waitlist/gpt-4-api
    ///  You can read the [API Docs](https://platform.openai.com/docs/api-reference/chat/create)
    public enum GPT4: String {
        
        /// More capable than any GPT-3.5 model, able to do more complex tasks, and optimized for chat. Will be updated with our latest model iteration.
        /// > Model Name: gpt-4
        case gpt4 = "gpt-4"
        
        /// Snapshot of gpt-4 from March 14th 2023. Unlike gpt-4, this model will not receive updates, and will be deprecated 3 months after a new version is released.
        /// > Model Name: gpt-4-0314
        case gpt4_0314 = "gpt-4-0314"
        
        /// Same capabilities as the base gpt-4 mode but with 4x the context length. Will be updated with our latest model iteration.
        /// > Model Name: gpt-4-32k
        case gpt4_32k = "gpt-4-32k"
        
        /// Snapshot of gpt-4-32 from March 14th 2023. Unlike gpt-4-32k, this model will not receive updates, and will be deprecated 3 months after a new version is released.
        /// > Model Name: gpt-4-32k
        case gpt4_32k_0314 = "gpt-4-32k-0314"
    }
    
    
    /// A set of models for the embedding
    /// You can read the [API Docs](https://platform.openai.com/docs/api-reference/embeddings)
    public enum Embedding: String {
        
        /// The new model, text-embedding-ada-002, replaces five separate models for text search, text similarity, and code search, and outperforms previous most capable model, Davinci, at most tasks, while being priced 99.8% lower.
        ///
        /// > Model Name: text-embedding-ada-002
        case ada = "text-embedding-ada-002"
    }
    
    /// A set of models for the moderations endpoint
    /// You can read the [API Docs](https://platform.openai.com/docs/api-reference/moderations)
    public enum Moderation: String {
        /// Default. Automatically upgraded over time.
        case latest = "text-moderation-latest"
        
        /// OpenAI will provide advanced notice before updating this model.
        /// Accuracy  may be slightly lower than for text-moderation-latest.
        case stable = "text-moderation-stable"
    }
}
