# OpenAI API Client Library in Swift

This is a wrapper library to access OpenAI HTTP API's. The full API docs can be found here:
https://beta.openai.com/api-docs

## Installation 💻

### Manual

Copy source files into your own project

### Swift Package Manager (Preferred)

You can use Swift Package Manager to integrate the library by adding the following dependency in your Package.swift file or by adding directly within Xcode

.Package(url: "https://github.com/adamrushy/OpenAISwift.git", majorVersion: 1)

## Example Usage 🤩

Import the module in your application.

import OpenAISwift

Set your API token from creating one here.

`let openAPI = OpenAISwift(authToken: "TOKEN")`

Create a call to the completions API, passing in the text prompt and the specific data model to be used.

openAPI.sendCompletion(with: "A random emoji", model: "text-davinci-003") { result, error in
    if let error {
        print("We have an error \(error)")
    }
            
if let result {
    print(result.choices.first?.text ?? "")
    }
}

The API will return an OpenAPI object containing the responding text items.

## Contribute ❤️

I created this mainly for fun, we can add more endpoints and explore the library even further. Feel free to raise a PR to help grow the library.

## Licence 📥

The MIT License (MIT)

Copyright (c) 2022 Adam Rush

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
