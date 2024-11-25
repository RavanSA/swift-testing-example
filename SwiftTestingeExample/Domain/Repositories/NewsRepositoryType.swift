//
//  NewsRepositoryType.swift
//  SwiftTestingeExample
//
//  Created by Revan SADIGLI on 21.11.24.
//

import Foundation

protocol NewsRepositoryType {
  func fetchNewsList(query: String, language: Languages) async throws -> [News]
}
