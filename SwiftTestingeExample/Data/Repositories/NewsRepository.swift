//
//  NewsRepository.swift
//  SwiftTestingeExample
//
//  Created by Revan SADIGLI on 21.11.24.
//

import Foundation

final class NewsRepository {
  private let dataTransferService: DataTransferService
  
  init(dataTransferService: DataTransferService) {
    self.dataTransferService = dataTransferService
  }
}

extension NewsRepository: NewsRepositoryType {
  func fetchNewsList(query: String, language: Languages) async throws -> [News] {
    let requestDTO = NewsRequestDTO(query: query, language: language)
    let endpoint = APIEndpoints.getNews(with: requestDTO)

    let responseDTO: NewsResponseDTO = try await dataTransferService.request(with: endpoint)
    
    return responseDTO.toDomain()
  }
}
