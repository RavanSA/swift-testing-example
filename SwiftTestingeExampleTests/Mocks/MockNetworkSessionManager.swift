//
//  MockNetworkSessionManager.swift
//  SwiftTestingeExample
//
//  Created by Revan SADIGLI on 24.11.24.
//

import Foundation
@testable import SwiftTestingeExample

final class MockNetworkSessionManager: NetworkSessionManager {
    var mockData: Data?
    var mockResponse: URLResponse?
    var mockError: Error?

    func request(_ request: URLRequest) async throws -> (Data, URLResponse) {
        if let error = mockError {
            throw error
        }
        guard let data = mockData, let response = mockResponse else {
            throw URLError(.badServerResponse)
        }
        return (data, response)
    }
}
