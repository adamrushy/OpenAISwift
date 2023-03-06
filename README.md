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

### Manual

Copy source files into your own project

### Swift Package Manager (Preferred)

You can use Swift Package Manager to integrate the library by adding the following dependency in your Package.swift file or by adding directly within Xcode

`.Package(url: "https://github.com/adamrushy/OpenAISwift.git", majorVersion: 1)`

## Example Usage 🤩

Import the module in your application.

`import OpenAISwift`

Set your API token from creating one [here](https://beta.openai.com/account/api-keys).

`let openAI = OpenAISwift(authToken: "TOKEN")`

Create a call to the completions API, passing in a text prompt.

```swift
openAI.sendCompletion(with: "Hello how are you", maxTokens: 100) { result in // Result<OpenAI, OpenAIError>
    switch result {
    case .success(let success):
        print(success.choices.first?.text ?? "")
    case .failure(let failure):
        print(failure.localizedDescription)
    }
}
```

The API will return an `OpenAI` object containing the corresponding text items.

You can also specify a different model to use for the completions. The `sendCompletion` method uses the `text-davinci-003` model by default.

```swift
openAI.sendCompletion(with: "A random emoji", model: .gpt3(.ada)) { result in // Result<OpenAI, OpenAIError>
    // switch on result to get the response or error
}
```
For a full list of the supported models see [OpenAIModelType.swift](https://github.com/adamrushy/OpenAISwift/blob/main/Sources/OpenAISwift/Models/OpenAIModelType.swift). For more information on the models see the [OpenAI API Documentation](https://beta.openai.com/docs/models).

OpenAISwift also supports Swift concurrency so you can use Swift’s async/await syntax to fetch completions.

```swift
do {
    let result = try await openAI.sendCompletion(with: "A random emoji")
} catch {
    print(error.localizedDescription)
}
```

The latest `gpt-3.5-turbo` model is available too : 

```swift
func chat() async {
    do {
        let chat: [ChatMessage] = [
            ChatMessage(role: .system, content: "You are a helpful assistant."),
            ChatMessage(role: .user, content: "Who won the world series in 2020?"),
            ChatMessage(role: .assistant, content: "The Los Angeles Dodgers won the World Series in 2020."),
            ChatMessage(role: .user, content: "Where was it played?")
        ]
                    
        let result = try await openAI.sendChat(with: chat)
        
        print(result.choices.first?.message?.content ?? "Nothing")
    } catch {
        print("Something went wrong")
    }
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
