//
//  NewsViewModelTests.swift
//  SwiftTestingeExample
//
//  Created by Revan SADIGLI on 24.11.24.
//

import Testing
@testable import SwiftTestingeExample
import Foundation

@Suite("News List ViewModel Tests")
struct NewsViewModelTests {
  private var viewModel: NewsViewModel!
  private var mockNewsUseCase: MockNewsUseCase!
  
  init() {
    mockNewsUseCase = MockNewsUseCase()
    let mockNewsUseCases = DIContainer.UseCases(newsUseCase: mockNewsUseCase)
    viewModel = NewsViewModel()
    viewModel.useCase = mockNewsUseCases
  }
  
  @Test("Test fetch news with valid response should update news")
  func testFetchNews_withValidResponse_shouldUpdateNews() async throws {
    let expectedNews = [
      News(id: "1", title: "News Title 1", link: "http://example.com/1", description: "Description 1", content: "Content 1", publishedDate: "2024-11-22", imageUrl: "http://example.com/image1.jpg"),
      News(id: "2", title: "News Title 2", link: "http://example.com/2", description: "Description 2", content: "Content 2", publishedDate: "2024-11-21", imageUrl: "http://example.com/image2.jpg")
    ]
    mockNewsUseCase.result = .success(expectedNews)
    
    viewModel.fetchNews()
    await Task.yield()
    
    #expect(viewModel.news == expectedNews)
  }
  
  @Test("Test fetch news with error response should not update news")
  func testFetchNews_withErrorResponse_shouldNotUpdateNews() async throws {
    let expectedError = NSError(domain: "NetworkError", code: 404, userInfo: nil)
    mockNewsUseCase.result = .failure(expectedError)
    
    viewModel.fetchNews()
    await Task.yield()
    #expect(viewModel.news.isEmpty)
  }
  
  @Test("Test fetch news with default query should use default query")
  func testFetchNews_withDefaultQuery_shouldUseDefaultQuery() async throws {
    let expectedNews = [
      News(id: "1", title: "Default Query News 1", link: "http://example.com/1", description: "Description 1", content: "Content 1", publishedDate: "2024-11-22", imageUrl: "http://example.com/image1.jpg")
    ]
    mockNewsUseCase.result = .success(expectedNews)
    
    viewModel.fetchNews()
    await Task.yield()
    
    #expect(viewModel.news == expectedNews)
  }
  
  @Test("Test fetch news with custom query should use custom query")
  func testFetchNews_withCustomQuery_shouldUseCustomQuery() async throws {
    let expectedQuery = "sportnews"
    let expectedNews = [
      News(id: "1", title: "Custom Query News 1", link: "http://example.com/1", description: "Description 1", content: "Content 1", publishedDate: "2024-11-22", imageUrl: "http://example.com/image1.jpg")
    ]
    mockNewsUseCase.result = .success(expectedNews)
    
    viewModel.fetchNews(query: expectedQuery)
    await Task.yield()
    
    #expect(viewModel.news == expectedNews)
  }
  
}
