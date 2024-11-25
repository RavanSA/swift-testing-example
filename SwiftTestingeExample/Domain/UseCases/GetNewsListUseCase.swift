//
//  GetNewsListUseCase.swift
//  SwiftTestingeExample
//
//  Created by Revan SADIGLI on 22.11.24.
//

import Foundation

protocol GetNewsListUseCaseType {
  func execute(
    requestValue: NewsListUseCaseRequestValue
  ) async throws -> [News]
}

class GetNewsListUseCase: GetNewsListUseCaseType {
  
  private let newsRepository: NewsRepositoryType
  
  init(newsRepository: NewsRepositoryType) {
    self.newsRepository = newsRepository
  }
  
  func execute(requestValue: NewsListUseCaseRequestValue) async throws -> [News] {
    do {
      return try await newsRepository.fetchNewsList(query: requestValue.query, language: requestValue.language)
    } catch {
      throw error
    }
  }
  
}

struct NewsListUseCaseRequestValue {
  let query: String
  let language: Languages
}

struct StubGetNewsListUseCase: GetNewsListUseCaseType {
  func execute(requestValue: NewsListUseCaseRequestValue) async throws -> [News] {
    return [News(id: "", title: "", link: "", description: "", content: "", publishedDate: "", imageUrl: "")]
  }
}
