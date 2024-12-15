//
//  Endpoint.swift
//  Sample Project
//
//  Created by Arrinal S on 14/12/24.
//

import Foundation

protocol Endpoint {
    var path: String { get }
    var method: HTTPMethod { get }
    var queryItems: [URLQueryItem] { get }
}

extension Endpoint {
    var queryItems: [URLQueryItem] {
        []
    }
}
