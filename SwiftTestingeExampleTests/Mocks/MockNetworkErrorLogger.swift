//
//  MockNetworkErrorLogger.swift
//  SwiftTestingeExample
//
//  Created by Revan SADIGLI on 24.11.24.
//

import Foundation
@testable import SwiftTestingeExample
    
final class MockNetworkErrorLogger: NetworkErrorLogger {
    var loggedRequest: URLRequest?
    var loggedResponseData: Data?
    var loggedResponse: URLResponse?
    var loggedError: Error?

    func log(request: URLRequest) {
        loggedRequest = request
    }

    func log(responseData data: Data?, response: URLResponse?) {
        loggedResponseData = data
        loggedResponse = response
    }

    func log(error: Error) {
        loggedError = error
    }
}
