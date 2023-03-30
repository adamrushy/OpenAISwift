import XCTest
@testable import OpenAISwift

final class OpenAISwiftTests: XCTestCase {
    private var validAuthToken: String!
    private var fakeAuthToken: String!
    private var mockUrlSession: URLSession!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        validAuthToken = "valid-token"
        fakeAuthToken = ""
        let configuraion = URLSessionConfiguration.ephemeral
        configuraion.protocolClasses = [MockURLProtocol.self]
        mockUrlSession = .init(configuration: configuraion)
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        MockURLProtocol.handlers.removeAll()
        validAuthToken = nil
        fakeAuthToken = nil
        mockUrlSession = nil
    }
    
    func testWrongApiKey() async throws {
        do {
            let errorData = try XCTUnwrap("""
            {
                "error": {
                    "message": "You didn't provide an API key.",
                    "type": "invalid_request_error",
                    "param": null,
                    "code": null
                }
            }
            """.data(using: .utf8))
            let expectedUrl = try XCTUnwrap(URL(string: "https://api.openai.com/v1/completions"))
            MockURLProtocol.handlers.add(match: { $0.url == expectedUrl },
                                         inspect: {
                XCTAssertEqual($0.allHTTPHeaderFields?["Content-Type"], "application/json")
                XCTAssertEqual($0.allHTTPHeaderFields?["Authorization"], "Bearer ")
            },
                                         result: .success(.init(statusCode: 200, data: errorData)))
            let sut = OpenAISwift(authToken: fakeAuthToken, config: .init(session: mockUrlSession))
            
            _ = try await sut.sendCompletion(with: "Write a haiku")
            
            XCTFail("sendCompletion must fail")
        } catch let OpenAIError.internalError(error) {
            XCTAssertEqual(error.message, "You didn't provide an API key.")
            XCTAssertEqual(error.type, "invalid_request_error")
            XCTAssertNil(error.param)
            XCTAssertNil(error.code)
        }
    }
    
    func testInvalidResponse() async throws {
        let responseData = try XCTUnwrap("{}".data(using: .utf8))
        let expectedUrl = try XCTUnwrap(URL(string: "https://api.openai.com/v1/completions"))
        let expectedToken = try XCTUnwrap(validAuthToken)
        MockURLProtocol.handlers.add(match: { $0.url == expectedUrl },
                                     inspect: {
            XCTAssertEqual($0.allHTTPHeaderFields?["Content-Type"], "application/json")
            XCTAssertEqual($0.allHTTPHeaderFields?["Authorization"], "Bearer \(expectedToken)")
        },
                                     result: .success(.init(statusCode: 500, data: responseData)))
        let sut = OpenAISwift(authToken: validAuthToken, config: .init(session: mockUrlSession))
        
        let response = try await sut.sendCompletion(with: "Write a haiku")
        
        XCTAssertEqual(response, .init(object: nil, model: nil, choices: nil, usage: nil, data: nil))
    }
    
    func testSuccess() async throws {
        let successData = try XCTUnwrap("""
        {
            "id":"001",
            "object":"text_completion",
            "created":1677223214,
            "model":"text-davinci-003",
            "choices":[
                {
                "text":"Summer sun warms my skin, Feel happiness radiates, Peaceful",
                "index":0,
                "logprobs":null,
                "finish_reason":"length"}
            ],
            "usage":{
                "prompt_tokens":4,
                "completion_tokens":16,
                "total_tokens":20
            }
        }
        """.data(using: .utf8))
        let expectedUrl = try XCTUnwrap(URL(string: "https://api.openai.com/v1/completions"))
        let expectedToken = try XCTUnwrap(validAuthToken)
        MockURLProtocol.handlers.add(match: { $0.url == expectedUrl },
                                     inspect: {
            XCTAssertEqual($0.allHTTPHeaderFields?["Content-Type"], "application/json")
            XCTAssertEqual($0.allHTTPHeaderFields?["Authorization"], "Bearer \(expectedToken)")
        },
                                     result: .success(.init(statusCode: 200, data: successData)))
        let sut = OpenAISwift(authToken: validAuthToken, config: .init(session: mockUrlSession))
        
        let response = try await sut.sendCompletion(with: "Write a haiku")
        
        XCTAssertEqual(response.model, "text-davinci-003")
        XCTAssertEqual(response.choices?.count, 1)
        XCTAssertEqual(response.choices?.first?.text, "Summer sun warms my skin, Feel happiness radiates, Peaceful")
    }
}
