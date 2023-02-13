//
//  Created by Adam Rush - OpenAISwift
//

import Foundation

public struct OpenAIResponse: Codable {
	public var error: OpenAIResponseError?
	
	public struct OpenAIResponseError: Codable {
		public var param: String?
		public var message: String?
		public var code: String?
		public var type: String?
	}
}

public struct OpenAI: Codable {
    public let object: String
    public let model: String?
    public let choices: [Choice]
}

public struct Choice: Codable {
    public let text: String
}
