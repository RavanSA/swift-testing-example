//
//  NewsViewModel.swift
//  SwiftTestingeExample
//
//  Created by Revan SADIGLI on 22.11.24.
//

import SwiftUI

@Observable
class NewsViewModel {
  var useCase: UseCaseType?
  var news: [News] = []
  
  public init() {}
  
  func fetchNews(query: String = Constants.SearchQuery.defaultValue) {
    guard let useCase else { return }
    Task {
      do {
        self.news = try await useCase.newsUseCase.execute(requestValue: NewsListUseCaseRequestValue(query: query, language: .az))
        print("Fetched News: \(news)")
      } catch {
        print("Error fetching news: \(error)")
      }
    }
  }
  
}
