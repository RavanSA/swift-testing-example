//
//  MockNewsUseCase.swift
//  SwiftTestingeExample
//
//  Created by Revan SADIGLI on 24.11.24.
//

import Foundation
@testable import SwiftTestingeExample

final class MockNewsUseCase: GetNewsListUseCaseType {
  var result: Result<[News], Error>?
  
  func execute(requestValue: NewsListUseCaseRequestValue) async throws -> [News] {
    guard let result = result else {
      throw NSError(domain: "MockError", code: 0, userInfo: nil)
    }
    switch result {
    case .success(let news):
      return news
    case .failure(let error):
      throw error
    }
  }
}
