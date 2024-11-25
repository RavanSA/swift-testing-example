//
//  MockNewsRepository.swift
//  SwiftTestingeExample
//
//  Created by Revan SADIGLI on 23.11.24.
//

import Foundation
@testable import SwiftTestingeExample

final class MockNewsRepository: NewsRepositoryType {
  var newsList: [News] = []
  var errorToThrow: Error? = nil
  
  func fetchNewsList(query: String, language: Languages) async throws -> [News] {
    if let error = errorToThrow {
      throw error
    }
    return newsList
  }
}
