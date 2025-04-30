//
//  Item.swift
//  MercadoLibreChallenge
//
//  Created by Brayan Bejarano on 24/04/25.
//

import Foundation

struct Item: Codable {
    let id: String
    let title: String
    let price: Double
    let thumbnail: String
    let condition: String
    let availableQuantity: Int
    let soldQuantity: Int
    let acceptsMercadopago: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case price
        case thumbnail
        case condition
        case availableQuantity = "available_quantity"
        case soldQuantity = "sold_quantity"
        case acceptsMercadopago = "accepts_mercadopago"
    }
    
    var formattedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 2
        formatter.locale = Locale(identifier: "es_AR")
        return formatter.string(from: NSNumber(value: price)) ?? "$\(price)"
    }
    
    var conditionDisplay: String {
        switch condition {
        case "new": return "Nuevo"
        case "used": return "Usado"
        case "reconditioned": return "Reacondicionado"
        default: return condition
        }
    }
}

extension Item: Equatable {
    static func == (lhs: Item, rhs: Item) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Item {
    static var mock: Item {
        return Item(
            id: "MLA123456789",
            title: "iPhone 13 Pro Max 256GB Plata Liberado",
            price: 1499.99,
            thumbnail: "https://http2.mlstatic.com/D_Q_NP_123456-MLA123456789_123456-O.webp",
            condition: "new",
            availableQuantity: 10,
            soldQuantity: 150,
            acceptsMercadopago: true
        )
    }
}
