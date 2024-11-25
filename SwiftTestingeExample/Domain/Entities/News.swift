//
//  News.swift
//  SwiftTestingeExample
//
//  Created by Revan SADIGLI on 21.11.24.
//

import Foundation

struct News: Equatable, Identifiable {
  typealias Identifier = String
  let id: Identifier
  let title: String
  let link: String
  let description: String
  let content: String
  let publishedDate: String
  let imageUrl: String
}
