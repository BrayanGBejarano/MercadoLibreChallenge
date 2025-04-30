//
//  SuggestionService.swift
//  MercadoLibreChallenge
//
//  Created by Brayan Bejarano on 27/04/25.
//

import Foundation

class SuggestionService {
    func fetchPopularProducts(completion: @escaping (Result<[SuggestedProduct], Error>) -> Void) {
        let mockProducts = [
            SuggestedProduct(
                id: "MLA1",
                title: "iPhone 13 Pro Max",
                price: 1499.99,
                thumbnail: "https://http2.mlstatic.com/D_Q_NP_123456-MLA123456789_123456-O.webp",
                isPopular: true
            ),
            SuggestedProduct(
                id: "MLA2",
                title: "iPhone 12",
                price: 999.99,
                thumbnail: "https://http2.mlstatic.com/D_Q_NP_123456-MLA987654321_123456-O.webp",
                isPopular: true
            ),
            SuggestedProduct(
                id: "MLA7",
                title: "Samsung Galaxy S22",
                price: 899.99,
                thumbnail: "https://http2.mlstatic.com/D_Q_NP_123456-MLA567891234_123456-O.webp",
                isPopular: true
            ),
            SuggestedProduct(
                id: "MLA11",
                title: "PlayStation 5",
                price: 799.99,
                thumbnail: "https://http2.mlstatic.com/D_Q_NP_123456-MLA432156789_123456-O.webp",
                isPopular: true
            ),
            SuggestedProduct(
                id: "MLA15",
                title: "Nintendo Switch OLED",
                price: 499.99,
                thumbnail: "https://http2.mlstatic.com/D_Q_NP_123456-MLA219876543_123456-O.webp",
                isPopular: true
            ),
            SuggestedProduct(
                id: "MLA13",
                title: "Apple Watch Series 8",
                price: 449.99,
                thumbnail: "https://http2.mlstatic.com/D_Q_NP_123456-MLA654321987_123456-O.webp",
                isPopular: true
            )
        ]
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
            completion(.success(mockProducts))
        }
    }
}
