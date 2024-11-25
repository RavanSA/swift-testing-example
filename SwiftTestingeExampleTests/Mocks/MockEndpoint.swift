//
//  MockEndpoint.swift
//  SwiftTestingeExample
//
//  Created by Revan SADIGLI on 24.11.24.
//

@testable import SwiftTestingeExample
import Foundation

struct MockEndpoint: Requestable {
    var path: String
    var isFullPath: Bool = false
    var method: HTTPMethodType = .get
    var headerParameters: [String: String] = [:]
    var queryParametersEncodable: Encodable? = nil
    var queryParameters: [String: Any] = [:]
    var bodyParametersEncodable: Encodable? = nil
    var bodyParameters: [String: Any] = [:]
    var bodyEncoder: BodyEncoder = JSONBodyEncoder()

    func urlRequest(with networkConfig: NetworkConfigurable) throws -> URLRequest {
        let url = try networkConfig.baseURL.appendingPathComponent(path)
        return URLRequest(url: url)
    }
}
