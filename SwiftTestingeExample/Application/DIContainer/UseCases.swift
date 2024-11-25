//
//  UseCases.swift
//  SwiftTestingeExample
//
//  Created by Revan SADIGLI on 22.11.24.
//

protocol UseCaseType {
  var newsUseCase: GetNewsListUseCaseType { get }
  static var defaultValue: Self { get }
}

extension DIContainer {
  struct UseCases: UseCaseType {
    let newsUseCase: GetNewsListUseCaseType
    
    init(newsUseCase: GetNewsListUseCaseType) {
      self.newsUseCase = newsUseCase
    }
    
    static var defaultValue: DIContainer.UseCases {
      .init(newsUseCase: StubGetNewsListUseCase())
    }
  }
}
