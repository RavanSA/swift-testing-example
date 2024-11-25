import Foundation

enum NetworkError: Error {
  case error(statusCode: Int, data: Data?)
  case notConnected
  case cancelled
  case generic(Error)
  case urlGeneration
}

protocol NetworkCancellable {
  func cancel()
}

extension URLSessionTask: NetworkCancellable {}

protocol NetworkService {
  func request(endpoint: Requestable) async throws -> Data
}

protocol NetworkSessionManager {
  func request(_ request: URLRequest) async throws -> (Data, URLResponse)
}

protocol NetworkErrorLogger {
  func log(request: URLRequest)
  func log(responseData data: Data?, response: URLResponse?)
  func log(error: Error)
}

final class DefaultNetworkService: NetworkService {
  private let config: NetworkConfigurable
  private let sessionManager: NetworkSessionManager
  private let logger: NetworkErrorLogger
  
  init(
    config: NetworkConfigurable,
    sessionManager: NetworkSessionManager = DefaultNetworkSessionManager(),
    logger: NetworkErrorLogger = DefaultNetworkErrorLogger()
  ) {
    self.sessionManager = sessionManager
    self.config = config
    self.logger = logger
  }
  
  func request(endpoint: Requestable) async throws -> Data {
    do {
      let urlRequest = try endpoint.urlRequest(with: config)
      logger.log(request: urlRequest)
      
      let (data, response) = try await sessionManager.request(urlRequest)
      logger.log(responseData: data, response: response)
      
      guard let httpResponse = response as? HTTPURLResponse else {
        throw NetworkError.generic(URLError(.badServerResponse))
      }
      
      guard (200...299).contains(httpResponse.statusCode) else {
        throw NetworkError.error(statusCode: httpResponse.statusCode, data: data)
      }
      
      return data
    } catch let error as NetworkError {
      logger.log(error: error)
      throw error
    } catch {
      let resolvedError = resolve(error: error)
      logger.log(error: resolvedError)
      throw resolvedError
    }
  }
  
  private func resolve(error: Error) -> NetworkError {
    let code = URLError.Code(rawValue: (error as NSError).code)
    switch code {
    case .notConnectedToInternet: return .notConnected
    case .cancelled: return .cancelled
    default: return .generic(error)
    }
  }
}

final class DefaultNetworkSessionManager: NetworkSessionManager {
  func request(_ request: URLRequest) async throws -> (Data, URLResponse) {
    try await withCheckedThrowingContinuation { continuation in
      let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
          continuation.resume(throwing: error)
        } else if let data = data, let response = response {
          continuation.resume(returning: (data, response))
        } else {
          continuation.resume(throwing: URLError(.badServerResponse))
        }
      }
      task.resume()
    }
  }
}

final class DefaultNetworkErrorLogger: NetworkErrorLogger {
  func log(request: URLRequest) {
    print("-------------")
    print("Request URL: \(String(describing: request.url))")
    print("Headers: \(String(describing: request.allHTTPHeaderFields))")
    print("Method: \(String(describing: request.httpMethod))")
    if let body = request.httpBody, let bodyString = String(data: body, encoding: .utf8) {
      print("Body: \(bodyString)")
    }
  }
  
  func log(responseData data: Data?, response: URLResponse?) {
    guard let data = data else { return }
    if let responseDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
      print("Response Data: \(responseDict.prettyPrint())")
    }
  }
  
  func log(error: Error) {
    print("Error: \(error)")
  }
}

extension NetworkError {
  var isNotFoundError: Bool { hasStatusCode(404) }
  
  func hasStatusCode(_ codeError: Int) -> Bool {
    switch self {
    case let .error(code, _):
      return code == codeError
    default:
      return false
    }
  }
}

extension Dictionary where Key == String {
  func prettyPrint() -> String {
    if let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted),
       let prettyString = String(data: data, encoding: .utf8) {
      return prettyString
    }
    return ""
  }
}

func printIfDebug(_ string: String) {
#if DEBUG
  print(string)
#endif
}
