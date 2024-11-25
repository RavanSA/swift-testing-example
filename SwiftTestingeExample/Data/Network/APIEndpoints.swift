//
//  APIEndpoints.swift
//  SwiftTestingeExample
//
//  Created by Revan SADIGLI on 21.11.24.
//

import Foundation

struct APIEndpoints {
  static func getNews(with newsRequestDTO: NewsRequestDTO) -> Endpoint<NewsResponseDTO> {
    return Endpoint(
      path: "1/latest",
      method: .get,
      queryParametersEncodable: newsRequestDTO
    )
  }
}
