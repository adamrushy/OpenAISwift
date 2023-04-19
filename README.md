[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fadamrushy%2FOpenAISwift%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/adamrushy/OpenAISwift)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fadamrushy%2FOpenAISwift%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/adamrushy/OpenAISwift)

![](https://img.shields.io/github/license/adamrushy/OpenAISwift)
![GitHub Workflow Status (with branch)](https://img.shields.io/github/actions/workflow/status/adamrushy/OpenAISwift/swift.yml?branch=main)
[![](https://img.shields.io/badge/SPM-supported-DE5C43.svg?style=flat)](https://swift.org/package-manager/)

[![Twitter Follow](https://img.shields.io/twitter/follow/adam9rush?style=social)](https://twitter.com/adam9rush)

# OpenAI API Client Library in Swift

This is a community-maintained library to access OpenAI HTTP API's. The full API docs can be found here:
https://beta.openai.com/docs

## Installation 💻

### Swift Package Manager (Preferred)

You can use Swift Package Manager to integrate the library by adding the following dependency in the `Package.swift` file or by adding it directly within Xcode.

`.package(url: "https://github.com/adamrushy/OpenAISwift.git", from: "1.2.0")`

### CocoaPods

[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa projects. For usage and installation instructions, visit their website. To integrate `OpenAISwift` into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'OpenAISwift'
```

### Manual

Copy the source files into your own project.

## Usage 🤩

Import the framework in your project:

`import OpenAISwift`

[Create an OpenAI API key](https://platform.openai.com/account/api-keys) and add it to your configuration:

`let openAI = OpenAISwift(authToken: "TOKEN")`

This framework supports Swift concurrency; each example below has both an async/await and completion handler variant.

### [Completions](https://platform.openai.com/docs/api-reference/completions)

Predict completions for input text.

```swift
openAI.sendCompletion(with: "Hello how are you") { result in // Result<OpenAI, OpenAIError>
    switch result {
    case .success(let success):
        print(success.choices.first?.text ?? "")
    case .failure(let failure):
        print(failure.localizedDescription)
    }
}
```

This returns an `OpenAI` object containing the completions.

Other API parameters are also supported:

```swift
do {
    let result = try await openAI.sendCompletion(
        with: "What's your favorite color?",
        model: .gpt3(.davinci), // optional `OpenAIModelType`
        maxTokens: 16,          // optional `Int?`
        temperature: 1          // optional `Double?`
    )
    // use result
} catch {
    // ...
}
```

For a full list of supported models, see [OpenAIModelType.swift](https://github.com/adamrushy/OpenAISwift/blob/main/Sources/OpenAISwift/Models/OpenAIModelType.swift). For more information on the models see the [OpenAI API Documentation](https://beta.openai.com/docs/models).

### [Chat](https://platform.openai.com/docs/api-reference/chat)

Get responses to chat conversations through ChatGPT (aka GPT-3.5) and GPT-4 (in beta).

```swift
do {
    let chat: [ChatMessage] = [
        ChatMessage(role: .system, content: "You are a helpful assistant."),
        ChatMessage(role: .user, content: "Who won the world series in 2020?"),
        ChatMessage(role: .assistant, content: "The Los Angeles Dodgers won the World Series in 2020."),
        ChatMessage(role: .user, content: "Where was it played?")
    ]
                
    let result = try await openAI.sendChat(with: chat)
    // use result
} catch {
    // ...
}
```

All API parameters are supported, except streaming message content before it is completed:

```swift
do {
    let chat: [ChatMessage] = [...]

    let result = try await openAI.sendChat(
        with: chat,
        model: .chat(.chatgpt),         // optional `OpenAIModelType`
        user: nil,                      // optional `String?`
        temperature: 1,                 // optional `Double?`
        topProbabilityMass: 1,          // optional `Double?`
        choices: 1,                     // optional `Int?`
        stop: nil,                      // optional `[String]?`
        maxTokens: nil,                 // optional `Int?`
        presencePenalty: nil,           // optional `Double?`
        frequencyPenalty: nil,          // optional `Double?`
        logitBias: nil                 // optional `[Int: Double]?` (see inline documentation)
    )
    // use result
} catch {
    // ...
}
```

### [Images (DALL·E)](https://platform.openai.com/docs/api-reference/images/create)

Generate an image based on a prompt.

```swift
openAI.sendImages(with: "A 3d render of a rocket ship", numImages: 1, size: .size1024) { result in // Result<OpenAI, OpenAIError>
    switch result {
    case .success(let success):
        print(success.data.first?.url ?? "")
    case .failure(let failure):
        print(failure.localizedDescription)
    }
}
```

### [Edits](https://platform.openai.com/docs/api-reference/edits)

Edits text based on a prompt and an instruction.

```swift
do {
    let result = try await openAI.sendEdits(
        with: "Improve the tone of this text.",
        model: .feature(.davinci),               // optional `OpenAIModelType`
        input: "I am resigning!"
    )
    // use result
} catch {
    // ...
}
```

### [Moderation](https://platform.openai.com/docs/api-reference/moderations)

Classifies text for moderation purposes (see OpenAI reference for more info).

```swift
do {
    let result = try await openAI.sendModeration(
        with: "Some harmful text...",
        model: .moderation(.latest)     // optional `OpenAIModelType`
    )
    // use result
} catch {
    // ...
}
```

### [Embeddings](https://platform.openai.com/docs/api-reference/embeddings)

Get a vector representation of a given input that can be easily consumed by machine learning models and algorithms.(see OpenAI reference for more info).

```swift
do {
    let result = try await openAI.sendEmbeddings(
        with: "The food was delicious and the waiter..."
    )
    // use result
} catch {
    // ...
}
```

## Contribute ❤️

I created this mainly for fun, we can add more endpoints and explore the library even further. Feel free to raise a PR to help grow the library.

## Licence 📥

The MIT License (MIT)

Copyright (c) 2022 Adam Rush

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
