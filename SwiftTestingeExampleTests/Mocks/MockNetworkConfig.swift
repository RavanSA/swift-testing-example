//
//  MockNetworkConfig.swift
//  SwiftTestingeExample
//
//  Created by Revan SADIGLI on 24.11.24.
//

@testable import SwiftTestingeExample
import Foundation

struct MockNetworkConfig: NetworkConfigurable {
    var baseURL: URL = URL(string: "https://api.example.com")!
    var queryParameters: [String: String] = ["apiKey": "test123"]
    var headers: [String: String] = ["Authorization": "Bearer token"]
}
