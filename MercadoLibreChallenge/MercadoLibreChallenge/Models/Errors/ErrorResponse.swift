//
//  ErrorResponse.swift
//  MercadoLibreChallenge
//
//  Created by Brayan Bejarano on 24/04/25.
//

import Foundation

struct ErrorResponse: Codable {
    let error: String
    let message: String
    let status: Int
    let cause: [String]?
    
    enum CodingKeys: String, CodingKey {
        case error
        case message
        case status
        case cause
    }
}
