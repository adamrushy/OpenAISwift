//
//  RunObject.swift
//
//
//  Created by Mark Hoath on 16/11/2023.
//

import Foundation

typealias RunListRequest = MessageListRequest

public enum RunObjectStatus: String, Codable {
    case queued, in_progress, requires_action, cancelling, cancelled, failed, completed, expired
}

public struct ToolCallsFunction: Codable {
    public let name: String
    public let arguements: String
}

public struct ToolsOutput: Codable {
    public let tool_call_id: String
    public let output: String
}

public struct ToolCalls: Codable {
    public let id: String
    public let type: String         //   always = "function"
    public let function: ToolCallsFunction
}

public struct SubmitToolOutputs: Codable {
    public let tool_calls: [ToolCalls]
}

public struct RequiredAction: Codable {
    public let type: String       //    always = "submit_tool_outputs"
    public let submit_tool_outputs: SubmitToolOutputs
}

public struct LastError: Codable {
    public let code: String
    public let message: String
}

public struct RunObject: Codable {
    public let id: String
    public let object: String       //  always = "thread.run"
    public let created_at: Int
    public let thread_id: String
    public let assistant_id: String
    public let status: RunObjectStatus
    public let required_action: RequiredAction
    public let last_error: LastError?
    public let expires_at: Int
    public let stared_at: Int?
    public let cancelled_at: Int?
    public let failed_at: Int?
    public let compelted_at: Int?
    public let model: String
    public let instructions: String
    public let metadata: [String:String] // 16 key value pairs. key Max 64 chars, value Max 512 chars.
}

public struct RunRequest: Codable {
    public let assistant_id: String
    public let model: String?
    public let instructions: String?
    public let tools: [Tools]?
    public let metadata: [String:String]?
}

public struct ThreadRun: Codable {
    public let messages: [Message]?
    public let metadate: [String:String]?
}

public struct ThreadRunRequest: Codable {
    public let assistant_id: String
    public let thread: ThreadRun?
    public let model: String?
    public let instructions: String?
    public let tools: [Tools]?
    public let metatdata: [String:String]?
}

public struct MessageID: Codable {
    public let message_id: String
}

public struct MessageCreation: Codable {
    public let type: String     //  always = "message_creation"
    public let message_creation: MessageID
}

public struct MessageToolCallsTypes: Codable {
    public let code_interpretor: CodeInterpretorTool?
    public let retrieval_tool: RetrievalTool?
    public let function_tool: FunctionTool?
}

public struct MessageToolCalls: Codable {
    public let type: String     //  always = "tool_calls"
    public let tool_calls: MessageToolCallsTypes
}

public struct StepDetails: Codable {
    public let message_creation: MessageCreation
    public let tool_calls: MessageToolCalls
}

public struct RunStepError: Codable {
    public let code: String
    public let message: String
}

public struct RunStep: Codable {
    public let id: String
    public let object: String
    public let created_at: Int
    public let assistant_id: String
    public let thread_id: String
    public let run_id: String
    public let type: String     //  either "message_creation" or "tool_calls"
    public let status: String   //  either "in_progress", "cancelled", "failed", "completed" or "expired"
    public let step_details: StepDetails
    public let last_error: RunStepError?
    public let expired_at: Int?
    public let cancelled_at: Int?
    public let failed_at: Int?
    public let completed_at: Int?
    public let metadata: [String:String]
    
}
