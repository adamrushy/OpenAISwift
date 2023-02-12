//
//  Created by Adam Rush - OpenAISwift
//

import Foundation

class Command: Encodable {
    var prompt: String
    var model: String
    var maxTokens: Int
	var temperature: Double
	var stream: Bool
	let stop:[String] = [
		"\n\n\n",
		"<|im_end|>"
	]
    
	init(prompt: String, model: String, maxTokens: Int, temperature: Double, stream: Bool) {
		self.prompt = prompt
        self.model = model
        self.maxTokens = maxTokens
		self.temperature = temperature
		self.stream = stream
    }
    
    enum CodingKeys: String, CodingKey {
        case prompt
        case model
        case maxTokens = "max_tokens"
		case temperature
		case stream
		case stop
    }
}
