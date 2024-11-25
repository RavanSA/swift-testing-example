//
//  AppEnviroment.swift
//  SwiftTestingeExample
//
//  Created by Revan SADIGLI on 22.11.24.
//

import Foundation

struct AppEnvironment {
  let container: DIContainer
}

extension AppEnvironment {
  
  static func bootstrap() -> AppEnvironment {
    
    let dataTransferService = configureDataTransferService()
    
    let newsRepository = configureNewsRepository(dataServiceTransfer: dataTransferService)
    
    let usecases = configuredUsecases(newsRepository: newsRepository)
    
    let diContainer = DIContainer(useCases: usecases)
    
    return AppEnvironment(container: diContainer)
  }
  
  private static func configureDataTransferService() -> DIContainer.DataTransferServiceDI {
    let appConfiguration = AppConfiguration()
    let apiDataTransferService: DataTransferService = {
      let config = ApiDataNetworkConfig(
        baseURL: URL(string: appConfiguration.apiBaseURL)!,
        queryParameters: [
          "apiKey": appConfiguration.apiKey,
          "language": NSLocale.preferredLanguages.first ?? "en"
        ]
      )
      
      let apiDataNetwork = DefaultNetworkService(config: config)
      return DefaultDataTransferService(with: apiDataNetwork)
    }()
    return .init(dataTransferService: apiDataTransferService)
  }
  
  private static func configureNewsRepository(dataServiceTransfer: DIContainer.DataTransferServiceDI) -> DIContainer.NewsRepository {
    let newsRepository = NewsRepository(dataTransferService: dataServiceTransfer.dataTransferService)
    
    return .init(newsRepository: newsRepository)
  }
  
  private static func configuredUsecases(
    newsRepository: DIContainer.NewsRepository
  ) -> DIContainer.UseCases {
    
    let newsUseCase = GetNewsListUseCase(newsRepository: newsRepository.newsRepository)
    
    return .init(newsUseCase: newsUseCase)
  }
  
}

extension DIContainer {
  struct NewsRepository {
    let newsRepository: NewsRepositoryType
  }
  
  struct DataTransferServiceDI {
    let dataTransferService: DataTransferService
  }
}
