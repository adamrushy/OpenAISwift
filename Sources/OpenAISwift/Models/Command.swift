//
//  Created by Adam Rush - OpenAISwift
//

import Foundation

class Command: Encodable {
    var prompt: String
    var model: String
    
    init(prompt: String, model: String) {
        self.prompt = prompt
        self.model = model
    }
    
    enum CodingKeys: String, CodingKey {
        case prompt
        case model
    }
}
