//
//  BaseServiceResponse.swift
//  Sample Project
//
//  Created by Arrinal S on 14/12/24.
//

import Foundation

struct BaseServiceResponse<T: Codable>: Codable {
    let status: String
    let code: Int
    let message: String
    let data: T?
    let timestamp: Date
    let path: String
}
