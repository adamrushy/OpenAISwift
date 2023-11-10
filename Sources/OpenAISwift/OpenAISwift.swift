import Foundation
#if canImport(FoundationNetworking) && canImport(FoundationXML)
import FoundationNetworking
import FoundationXML
#endif

public enum OpenAIError: Error {
    case networkError(code: Int)
    case genericError(error: Error)
    case decodingError(error: Error)
    case chatError(error: ChatError.Payload)
}

public class OpenAISwift {
    fileprivate let config: Config
    let handler = ServerSentEventsHandler()

    /// Configuration object for the client
    public struct Config {
        
        /// Initialiser
        /// - Parameter session: the session to use for network requests.
        public init(baseURL: String, endpointPrivider: OpenAIEndpointProvider, session: URLSession, authorizeRequest: @escaping (inout URLRequest) -> Void) {
            self.baseURL = baseURL
            self.endpointProvider = endpointPrivider
            self.authorizeRequest = authorizeRequest
            self.session = session
        }
        let baseURL: String
        let endpointProvider: OpenAIEndpointProvider
        let session:URLSession
        let authorizeRequest: (inout URLRequest) -> Void
        
        public static func makeDefaultOpenAI(apiKey: String) -> Self {
            .init(baseURL: "https://api.openai.com",
                  endpointPrivider: OpenAIEndpointProvider(source: .openAI),
                  session: .shared,
                  authorizeRequest: { request in
                    request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
            })
        }
    }
    
    @available(*, deprecated, message: "Use init(config:) instead")
    public convenience init(authToken: String) {
        self.init(config: .makeDefaultOpenAI(apiKey: authToken))
    }
    
    public init(config: Config) {
        self.config = config
    }
}

extension OpenAISwift {

    func makeRequest(request: URLRequest, completionHandler: @escaping (Result<Data, Error>) -> Void) {
        let session = config.session
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completionHandler(.failure(error))
            } else if let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
                completionHandler(.failure(OpenAIError.networkError(code: response.statusCode)))
            } else if let data = data {
                completionHandler(.success(data))
            } else {
                let error = NSError(domain: "OpenAI", code: 6666, userInfo: [NSLocalizedDescriptionKey: "Unknown error"])
                completionHandler(.failure(OpenAIError.genericError(error: error)))
            }
        }
        task.resume()
    }
    
    func prepareRequest<BodyType: Encodable>(_ endpoint: OpenAIEndpointProvider.API, body: BodyType) -> URLRequest {
        var urlComponents = URLComponents(url: URL(string: config.baseURL)!, resolvingAgainstBaseURL: true)
        urlComponents?.path = config.endpointProvider.getPath(api: endpoint)
        var request = URLRequest(url: urlComponents!.url!)
        request.httpMethod = config.endpointProvider.getMethod(api: endpoint)
        
        config.authorizeRequest(&request)
        
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(body) {
            request.httpBody = encoded
        }
        
        return request
    }
            
    func prepareMultipartFormDataRequest(_ endpoint: OpenAIEndpointProvider.API, imageData: Data, maskData: Data?, prompt: String, n: Int, size: String) -> URLRequest {
        var urlComponents = URLComponents(url: URL(string: config.baseURL)!, resolvingAgainstBaseURL: true)
        urlComponents?.path = config.endpointProvider.getPath(api: endpoint)
        var request = URLRequest(url: urlComponents!.url!)
        request.httpMethod = config.endpointProvider.getMethod(api: endpoint)
        
        config.authorizeRequest(&request)
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
                
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.png\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)
        
        if let maskData = maskData {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"mask\"; filename=\"mask.png\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
            body.append(maskData)
            body.append("\r\n".data(using: .utf8)!)
        }
        
        // Add the "prompt" field.
        
        if !prompt.isEmpty {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"prompt\"\r\n\r\n".data(using: .utf8)!)
            body.append(prompt.data(using: .utf8)!)
            body.append("\r\n".data(using: .utf8)!)
        }
        
        // Add the "n" field.
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"n\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(n)".data(using: .utf8)!)
        body.append("\r\n".data(using: .utf8)!)
        
        // Add the "size" field.
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"size\"\r\n\r\n".data(using: .utf8)!)
        body.append(size.data(using: .utf8)!)
        body.append("\r\n".data(using: .utf8)!)
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        return request
    }
}
