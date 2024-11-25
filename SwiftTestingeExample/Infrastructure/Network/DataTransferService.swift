import Foundation

enum DataTransferError: Error {
  case noResponse
  case parsing(Error)
  case networkFailure(NetworkError)
  case resolvedNetworkFailure(Error)
}

protocol DataTransferService {
  func request<T: Decodable, E: ResponseRequestable>(
    with endpoint: E
  ) async throws -> T where E.Response == T
}

protocol DataTransferErrorResolver {
  func resolve(error: NetworkError) -> Error
}

protocol ResponseDecoder {
  func decode<T: Decodable>(_ data: Data) throws -> T
}

protocol DataTransferErrorLogger {
  func log(error: Error)
}

final class DefaultDataTransferService: DataTransferService {
  private let networkService: NetworkService
  private let errorResolver: DataTransferErrorResolver
  private let errorLogger: DataTransferErrorLogger
  
  init(
    with networkService: NetworkService,
    errorResolver: DataTransferErrorResolver = DefaultDataTransferErrorResolver(),
    errorLogger: DataTransferErrorLogger = DefaultDataTransferErrorLogger()
  ) {
    self.networkService = networkService
    self.errorResolver = errorResolver
    self.errorLogger = errorLogger
  }
  
  func request<T: Decodable, E: ResponseRequestable>(
    with endpoint: E
  ) async throws -> T where E.Response == T {
    do {
      let data = try await networkService.request(endpoint: endpoint)
      let decoded: T = try decode(data: data, decoder: endpoint.responseDecoder)
      return decoded
    } catch let networkError as NetworkError {
      self.errorLogger.log(error: networkError)
      throw resolve(networkError: networkError)
    } catch {
      self.errorLogger.log(error: error)
      throw DataTransferError.parsing(error)
    }
  }
  
  private func decode<T: Decodable>(
    data: Data?,
    decoder: ResponseDecoder
  ) throws -> T {
    guard let data = data else { throw DataTransferError.noResponse }
    return try decoder.decode(data)
  }
  
  private func resolve(networkError error: NetworkError) -> DataTransferError {
    let resolvedError = self.errorResolver.resolve(error: error)
    return resolvedError is NetworkError
    ? .networkFailure(error)
    : .resolvedNetworkFailure(resolvedError)
  }
}

final class DefaultDataTransferErrorLogger: DataTransferErrorLogger {
  init() { }
  
  func log(error: Error) {
    print("-------------")
    print("\(error)")
  }
}

class DefaultDataTransferErrorResolver: DataTransferErrorResolver {
  init() { }
  
  func resolve(error: NetworkError) -> Error {
    return error
  }
}

class JSONResponseDecoder: ResponseDecoder {
  private let jsonDecoder = JSONDecoder()
  init() { }
  
  func decode<T: Decodable>(_ data: Data) throws -> T {
    return try jsonDecoder.decode(T.self, from: data)
  }
}

class RawDataResponseDecoder: ResponseDecoder {
  init() { }
  
  enum CodingKeys: String, CodingKey {
    case `default` = ""
  }
  
  func decode<T: Decodable>(_ data: Data) throws -> T {
    if T.self is Data.Type, let data = data as? T {
      return data
    } else {
      let context = DecodingError.Context(
        codingPath: [CodingKeys.default],
        debugDescription: "Expected Data type"
      )
      throw Swift.DecodingError.typeMismatch(T.self, context)
    }
  }
}

extension NetworkService {
  func request(endpoint: Requestable) async throws -> Data {
    return try await self.request(endpoint: endpoint)
  }
}
