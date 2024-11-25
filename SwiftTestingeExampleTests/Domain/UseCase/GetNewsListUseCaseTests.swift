//
//  GetNewsListUseCase.swift
//  SwiftTestingeExample
//
//  Created by Revan SADIGLI on 23.11.24.
//

import Testing
@testable import SwiftTestingeExample
import Foundation

@Suite("Fetching News List UseCase Test")
struct GetNewsListUseCaseTests {
  let useCase: GetNewsListUseCase
  let mockRepository: MockNewsRepository
  
  init() {
    self.mockRepository = MockNewsRepository()
    self.useCase = GetNewsListUseCase(newsRepository: mockRepository)
  }
  
  @Test("Test fetch news list with valid response should return news list")
  func testFetchNewsList_withValidResponse_shouldReturnNewsList() async throws {
    mockRepository.newsList = [
      News(id: "1", title: "News Title 1", link: "http://example.com/1", description: "Description 1", content: "Content 1", publishedDate: "2024-11-22", imageUrl: "http://example.com/image1.jpg"),
      News(id: "2", title: "News Title 2", link: "http://example.com/2", description: "Description 2", content: "Content 2", publishedDate: "2024-11-21", imageUrl: "http://example.com/image2.jpg")
    ]
    
    let result = try await useCase.execute(requestValue: NewsListUseCaseRequestValue(query: "test", language: .az))
    
    #expect(result == mockRepository.newsList)
  }
  
  @Test("Test fetch news list with error response should throw error")
  func testFetchNewsList_withErrorResponse_shouldThrowError() async throws {
    let expectedError = NSError(domain: "NetworkError", code: 404, userInfo: nil)
    mockRepository.errorToThrow = expectedError
    
    do {
      _ = try await useCase.execute(requestValue: NewsListUseCaseRequestValue(query: "test", language: .az))
      Issue.record("Expected an error to be thrown, but no error was thrown.")
    } catch {
      #expect(error as NSError == expectedError)
    }
  }
  
}
