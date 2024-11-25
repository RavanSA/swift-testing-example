//
//  AppConfiguration.swift
//  SwiftTestingeExample
//
//  Created by Revan SADIGLI on 20.11.24.
//

import Foundation

final class AppConfiguration {
  lazy var apiKey: String = {
    guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "ApiKey") as? String else {
      print("apikey", apiKey)
      fatalError("ApiKey must not be empty in plist")
    }
    return apiKey
  }()
  lazy var apiBaseURL: String = {
    guard let apiBaseURL = Bundle.main.object(forInfoDictionaryKey: "ApiBaseURL") as? String else {
      fatalError("ApiBaseURL must not be empty in plist")
    }
    return apiBaseURL
  }()
}