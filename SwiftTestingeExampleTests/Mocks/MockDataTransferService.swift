//
//  MockDataTransferService.swift
//  SwiftTestingeExample
//
//  Created by Revan SADIGLI on 24.11.24.
//

import Foundation
@testable import SwiftTestingeExample

final class MockDataTransferService: DataTransferService {

  var result: Result<Any, Error>?
  
  func request<T, E>(with endpoint: E) async throws -> T where T : Decodable, T == E.Response, E : SwiftTestingeExample.ResponseRequestable {
    guard let result = result else {
      throw NSError(domain: "MockDataTransferServiceError", code: -1, userInfo: nil)
    }
    switch result {
    case .success(let data):
      guard let decodedData = data as? T else {
        throw NSError(domain: "DecodingError", code: -1, userInfo: nil)
      }
      return decodedData
    case .failure(let error):
      throw error
    }
  }
}
