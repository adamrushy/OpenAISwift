import XCTest
@testable import OpenAISwift

final class OpenAISwiftTests: XCTestCase {
  
  @available(macOS 10.15, iOS 13, watchOS 6, tvOS 13, *)
  func testSendCompletion() async throws {
    
    #warning("please create your personal api key")
    let apiKey = "SET YOUR OWN API KEY"
    let openAPI = OpenAISwift(authToken: apiKey)

    do {
      let result = try await openAPI.sendCompletion(with: "A random emoji")
      
      XCTAssertNotNil(result)
      
    } catch {
      XCTAssertNil(error)
    }
  }
  
  @available(macOS 10.15, iOS 13, watchOS 6, tvOS 13, *)
  func testSendCompletionWithInvalidApiKey() async throws {
    
    let apiKey = "INVALID API KEY"
    let openAPI = OpenAISwift(authToken: apiKey)

    do {
      let result = try await openAPI.sendCompletion(with: "A random emoji")
      
      XCTAssertNil(result)
      
    } catch {
      XCTAssertNotNil(error)
    }
  }
}
