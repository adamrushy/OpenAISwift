//
//  File.swift
//  
//
//  Created by Mark Hoath on 15/11/2023.
//

import Foundation


public struct FineTuningError: Codable {
    public let code: String
    public let message: String
    public let param: String?
}

public struct FineTuningHyperParams: Codable {
    public let batch_size: String?
    public let learning_rate_multiplier: String?
    public let n_epochs: String?
}

public struct FineTuning: Codable {
    
    public let id: String
    public let created_at: Int
    public let error: FineTuningError?
    public let fine_tuned_model: String?
    public let finished_at: Int
    public let hyperparameters: FineTuningHyperParams?
    public let model: String
    public let object: String
    public let organization_id: String
    public let results_files: [String]
    public let status: String
    public let trained_tokens: Int?
    public let training_file: String
    public let validation_file: String?
}

public struct FineTuningRequest: Codable {
    public let model: String
    public let training_file: String
    public let hyperparameters: FineTuningHyperParams?
    public let suffix: String?
    public let validation_file: String?
}

public struct FineTuningListRequest: Codable {
    public let after: String?
    public let limit: Int?
}

public struct FineTuningEvent: Codable {
    public let id: String
    public let created_at: Int
    public let level: String
    public let message: String
    public let object: String
}

