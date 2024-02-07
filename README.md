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

### Manual

Copy the source files into your own project.

## Usage 🤩

Import the framework in your project:

`import OpenAISwift`

[Create an OpenAI API key](https://platform.openai.com/account/api-keys) and add it to your configuration:

let TOKEN = "sk-...... "

let openAI: OpenAISwift = OpenAISwift(config: OpenAISwift.Config.makeDefaultOpenAI(apiKey: "TOKEN"))


To follow [OpenAI requirements](https://platform.openai.com/docs/api-reference/authentication) 

>  Remember that your API key is a secret! Do not share it with others or expose it in any client-side code (browsers, apps). Production requests must be routed through your own backend server where your API key can be securely loaded from an environment variable or key management service.

and basic industrial safety you should not call OpenAI API directly. 


## Contribute ❤️

I created this mainly for fun, we can add more endpoints and explore the library even further. Feel free to raise a PR to help grow the library.

## Licence 📥

The MIT License (MIT)

Copyright (c) 2022 Adam Rush

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
