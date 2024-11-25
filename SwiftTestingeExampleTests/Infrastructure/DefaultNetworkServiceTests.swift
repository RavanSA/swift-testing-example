//
//  DefaultNetworkServiceTests.swift
//  SwiftTestingeExample
//
//  Created by Revan SADIGLI on 24.11.24.
//

import Testing
import Foundation
@testable import SwiftTestingeExample

@Suite("Generic Network Tests")
struct DefaultNetworkServiceTests {
  var networkService: DefaultNetworkService!
  var mockSessionManager: MockNetworkSessionManager!
  var mockLogger: MockNetworkErrorLogger!
  var mockConfig: MockNetworkConfig!
  
  init() {
    mockSessionManager = MockNetworkSessionManager()
    mockLogger = MockNetworkErrorLogger()
    mockConfig = MockNetworkConfig()
    
    networkService = DefaultNetworkService(
      config: mockConfig,
      sessionManager: mockSessionManager,
      logger: mockLogger
    )
  }
  
  @Test("Test request with valid response should return data")
  func testRequest_withValidResponse_shouldReturnData() async throws {
    let expectedData = "{\"key\": \"value\"}".data(using: .utf8)!
    let expectedResponse = HTTPURLResponse(url: mockConfig.baseURL, statusCode: 200, httpVersion: nil, headerFields: nil)
    mockSessionManager.mockData = expectedData
    mockSessionManager.mockResponse = expectedResponse
    
    let endpoint = MockEndpoint(path: "test/endpoint")
    
    let data = try await networkService.request(endpoint: endpoint)
    
    #expect(data == expectedData)
    #expect(mockLogger.loggedRequest != nil)
    #expect(mockLogger.loggedResponseData == expectedData)
    #expect(mockLogger.loggedResponse as? HTTPURLResponse == expectedResponse)
  }
  
  @Test("Test request with valid response should throw network error")
  func testRequest_withServerError_shouldThrowNetworkError() async throws {
    let errorData = "{\"error\": \"Not Found\"}".data(using: .utf8)!
    let serverErrorResponse = HTTPURLResponse(url: mockConfig.baseURL, statusCode: 404, httpVersion: nil, headerFields: nil)
    mockSessionManager.mockData = errorData
    mockSessionManager.mockResponse = serverErrorResponse
    
    let endpoint = MockEndpoint(path: "test/endpoint")
    
    do {
      _ = try await networkService.request(endpoint: endpoint)
      Issue.record("Expected a NetworkError to be thrown, but it was not.")
    } catch let error as NetworkError {
      switch error {
      case .error(let statusCode, let data):
        #expect(statusCode == 404)
        #expect(data == errorData)
      default:
        Issue.record("Unexpected error type: \(error)")
      }
    }
  }
    
}
