//
//  NewsResponseDTO.swift
//  SwiftTestingeExample
//
//  Created by Revan SADIGLI on 21.11.24.
//

import Foundation

struct NewsResponseDTO: Decodable {
  let status: NewsResponseDTO.Status
  let totalResults: Int
  let results: [NewsDTO]
}

extension NewsResponseDTO {
  struct NewsDTO: Decodable {
    let aiRegion: String
    let sourceIcon: String?
    let aiTag: String
    let sentiment: String
    let pubDate: String
    let content: String
    let pubDateTZ: String
    let articleId: String
    let creator: [String]?
    let sourceName: String
    let title: String
    let aiOrg: String
    let sourcePriority: Int
    let country: [String]
    let description: String?
    let sourceUrl: String
    let imageUrl: String?
    let keywords: [String]?
    let category: [String]
    let duplicate: Bool
    let sourceId: String
    let language: String
    let sentimentStats: String
    let link: String
    let videoUrl: String?
    
    private enum CodingKeys: String, CodingKey {
      case aiRegion = "ai_region"
      case sourceIcon = "source_icon"
      case aiTag = "ai_tag"
      case sentiment
      case pubDate
      case content
      case pubDateTZ = "pubDateTZ"
      case articleId = "article_id"
      case creator
      case sourceName = "source_name"
      case title
      case aiOrg = "ai_org"
      case sourcePriority = "source_priority"
      case country
      case description
      case sourceUrl = "source_url"
      case imageUrl = "image_url"
      case keywords
      case category
      case duplicate
      case sourceId = "source_id"
      case language
      case sentimentStats = "sentiment_stats"
      case link
      case videoUrl = "video_url"
    }
  }
}


extension NewsResponseDTO {
  enum Status: String, Codable {
    case success = "success"
    case failure = "fail"
  }
}

extension NewsResponseDTO {
  func toDomain() -> [News] {
    return results.map { newsDTO in
      News(
        id: newsDTO.articleId,
        title: newsDTO.title,
        link: newsDTO.link,
        description: newsDTO.description ?? "",
        content: newsDTO.content,
        publishedDate: newsDTO.pubDate,
        imageUrl: newsDTO.imageUrl ?? Constants.DefaultImage.defaultImageURL
      )
    }
  }
}
