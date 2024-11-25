//
//  MoviesRequestDTO.swift
//  SwiftTestingeExample
//
//  Created by Revan SADIGLI on 21.11.24.
//

import Foundation

struct NewsRequestDTO: Encodable {
  let query: String
  let language: Languages
  
  enum CodingKeys: String, CodingKey {
      case query = "q"
      case language
  }
}

enum Languages: String, Encodable {
  case az = "az"
  case en = "en"
  case ru = "ru"
}
