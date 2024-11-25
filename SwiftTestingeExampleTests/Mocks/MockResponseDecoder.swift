//
//  MockResponseDecoder.swift
//  SwiftTestingeExample
//
//  Created by Revan SADIGLI on 24.11.24.
//

import Foundation
@testable import SwiftTestingeExample

struct MockResponseDecoder: ResponseDecoder {
    func decode<T>(_ data: Data) throws -> T where T : Decodable {
        return try JSONDecoder().decode(T.self, from: data)
    }
}
