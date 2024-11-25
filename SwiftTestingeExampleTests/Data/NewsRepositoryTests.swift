//
//  NewsRepositoryTests.swift
//  SwiftTestingeExample
//
//  Created by Revan SADIGLI on 24.11.24.
//

import Testing
@testable import SwiftTestingeExample
import Foundation

@Suite("News Repository Test") 
struct NewsRepositoryTests {
  private var repository: NewsRepository!
  private var mockDataTransferService: MockDataTransferService!
  
  init() {
    mockDataTransferService = MockDataTransferService()
    repository = NewsRepository(dataTransferService: mockDataTransferService)
  }
  
  @Test("Fetch news list with valid response should return news list")
  func testFetchNewsList_withValidResponse_shouldReturnNewsList() async throws {
    let mockResponseDTO = NewsResponseDTO(
      status: .success,
      totalResults: 1,
      results: [
        NewsResponseDTO.NewsDTO(
          aiRegion: "region1",
          sourceIcon: "icon1",
          aiTag: "tag1",
          sentiment: "positive",
          pubDate: "2024-11-22",
          content: "Content 1",
          pubDateTZ: "GMT+3",
          articleId: "123",
          creator: ["Author1"],
          sourceName: "Source1",
          title: "News Title 1",
          aiOrg: "Org1",
          sourcePriority: 1,
          country: ["US"],
          description: "Description 1",
          sourceUrl: "http://example.com/1",
          imageUrl: "http://example.com/image1.jpg",
          keywords: ["Keyword1"],
          category: ["Category1"],
          duplicate: false,
          sourceId: "source1",
          language: "en",
          sentimentStats: "Positive",
          link: "http://example.com/1",
          videoUrl: nil
        )
      ]
    )
    
    mockDataTransferService.result = .success(mockResponseDTO)
    
    let newsList = try await repository.fetchNewsList(query: "test", language: .az)
    
    #expect(newsList.count == 1)
    let firstNews = newsList.first
    #expect(firstNews?.id == "123")
    #expect(firstNews?.title == "News Title 1")
    #expect(firstNews?.link == "http://example.com/1")
  }
  
  @Test("Fetch news list with valid response should throw error")
  func testFetchNewsList_withErrorResponse_shouldThrowError() async throws {
    let expectedError = NSError(domain: "NetworkError", code: 404, userInfo: nil)
    mockDataTransferService.result = .failure(expectedError)
    
    do {
      _ = try await repository.fetchNewsList(query: "test", language: .az)
      Issue.record("Expected an error to be thrown, but no error was thrown.")
    } catch {
      //Issue.record("Expected an error to be thrown")
    }
  }
  
}
