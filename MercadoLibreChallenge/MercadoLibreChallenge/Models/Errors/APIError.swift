//
//  APIError.swift
//  MercadoLibreChallenge
//
//  Created by Brayan Bejarano on 25/04/25.
//

import Foundation

enum APIError: Error, Equatable {
    case invalidURL
    case requestFailed(description: String)
    case invalidResponse
    case noData
    case decodingFailed(description: String)
    case serverError(code: Int, message: String?)
    case itemNotFound
    
    // Implementación de Equatable
    static func == (lhs: APIError, rhs: APIError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL):
            return true
        case let (.requestFailed(lhsDesc), .requestFailed(rhsDesc)):
            return lhsDesc == rhsDesc
        case (.invalidResponse, .invalidResponse):
            return true
        case (.noData, .noData):
            return true
        case let (.decodingFailed(lhsDesc), .decodingFailed(rhsDesc)):
            return lhsDesc == rhsDesc
        case let (.serverError(lhsCode, lhsMsg), .serverError(rhsCode, rhsMsg)):
            return lhsCode == rhsCode && lhsMsg == rhsMsg
        case (.itemNotFound, .itemNotFound):
            return true
        default:
            return false
        }
    }
}
