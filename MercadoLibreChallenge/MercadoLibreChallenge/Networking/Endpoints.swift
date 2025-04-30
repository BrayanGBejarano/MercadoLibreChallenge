//
//  Endpoints.swift
//  MercadoLibreChallenge
//
//  Created by Brayan Bejarano on 24/04/25.
//

import Foundation

enum Endpoint {
    case search(query: String)
    case itemDetails(id: String)
    
    private var path: String {
        switch self {
        case .search:
            return "/sites/MCO/search"
        case .itemDetails(let id):
            return "/items/\(id)"
        }
    }
    
    private var queryItems: [URLQueryItem] {
        switch self {
        case .search(let query):
            return [
                URLQueryItem(name: "q", value: query),
                URLQueryItem(name: "limit", value: "50")
            ]
        case .itemDetails:
            return []
        }
    }
    
    func buildURL(baseURL: String) -> URL? {
        var components = URLComponents(string: baseURL)
        components?.path = path
        components?.queryItems = queryItems
        
        print("URL construida: \(components?.url?.absoluteString ?? "Inválida")")
        return components?.url
    }
}
