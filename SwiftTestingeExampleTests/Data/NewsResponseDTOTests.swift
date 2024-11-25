//
//  NewsResponseDTOTests.swift
//  SwiftTestingeExample
//
//  Created by Revan SADIGLI on 24.11.24.
//

import Testing
@testable import SwiftTestingeExample

@Suite("News Response DTO Mapper to Entity Tests")
struct NewsResponseDTOTests {
  
  @Test("Test to domain with valid DTO should return correct domain object")
  func testToDomain_withValidDTO_shouldReturnCorrectDomainObjects() throws {
    let sampleDTO = NewsResponseDTO(
      status: .success,
      totalResults: 2,
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
        ),
        NewsResponseDTO.NewsDTO(
          aiRegion: "region2",
          sourceIcon: nil,
          aiTag: "tag2",
          sentiment: "neutral",
          pubDate: "2024-11-21",
          content: "Content 2",
          pubDateTZ: "GMT+2",
          articleId: "456",
          creator: nil,
          sourceName: "Source2",
          title: "News Title 2",
          aiOrg: "Org2",
          sourcePriority: 2,
          country: ["UK"],
          description: nil,
          sourceUrl: "http://example.com/2",
          imageUrl: nil,
          keywords: nil,
          category: ["Category2"],
          duplicate: false,
          sourceId: "source2",
          language: "en",
          sentimentStats: "Neutral",
          link: "http://example.com/2",
          videoUrl: "http://example.com/video.mp4"
        )
      ]
    )
    
    let domainObjects = sampleDTO.toDomain()
    
    #expect(domainObjects.count == 2)
    
    let firstNews = domainObjects[0]
    #expect(firstNews.id == "123")
    #expect(firstNews.title == "News Title 1")
    #expect(firstNews.link == "http://example.com/1")
    #expect(firstNews.description == "Description 1")
    #expect(firstNews.content == "Content 1")
    #expect(firstNews.publishedDate == "2024-11-22")
    #expect(firstNews.imageUrl == "http://example.com/image1.jpg")
    
    let secondNews = domainObjects[1]
    #expect(secondNews.id == "456")
    #expect(secondNews.title == "News Title 2")
    #expect(secondNews.link == "http://example.com/2")
    #expect(secondNews.description == "")
    #expect(secondNews.content == "Content 2")
    #expect(secondNews.publishedDate == "2024-11-21")
    #expect(secondNews.imageUrl == Constants.DefaultImage.defaultImageURL)
  }
  
  @Test("Test to domain with empty results should return empty array")
  func testToDomain_withEmptyResults_shouldReturnEmptyArray() throws {
    let emptyDTO = NewsResponseDTO(
      status: .success,
      totalResults: 0,
      results: []
    )
    
    let domainObjects = emptyDTO.toDomain()
    
    #expect(domainObjects.isEmpty)
  }
  
}
