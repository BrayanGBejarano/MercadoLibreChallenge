//
//  SuggestedProduct.swift
//  MercadoLibreChallenge
//
//  Created by Brayan Bejarano on 27/04/25.
//

import Foundation

struct SuggestedProduct {
    let id: String
    let title: String
    let price: Double
    let thumbnail: String
    let isPopular: Bool
    
    var formattedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: price)) ?? "$\(price)"
    }
}
