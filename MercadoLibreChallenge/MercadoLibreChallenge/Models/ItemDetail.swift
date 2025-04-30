//
//  ItemDetail.swift
//  MercadoLibreChallenge
//
//  Created by Brayan Bejarano on 24/04/25.
//

import Foundation

struct ItemDetail: Codable {
    let id: String
    let title: String
    let price: Double
    let currencyId: String
    let pictures: [Picture]
    let condition: String
    let soldQuantity: Int
    let availableQuantity: Int
    let warranty: String?
    let attributes: [Attribute]?
    let descriptions: [Description]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case price
        case currencyId = "currency_id"
        case pictures
        case condition
        case soldQuantity = "sold_quantity"
        case availableQuantity = "available_quantity"
        case warranty
        case attributes
        case descriptions
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
    
    var description: String? {
        return descriptions?.first?.plainText
    }
}

// MARK: - Submodels
struct Picture: Codable {
    let id: String
    let url: String
    let secureUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case url
        case secureUrl = "secure_url"
    }
}

struct Attribute: Codable {
    let id: String
    let name: String
    let valueId: String?
    let valueName: String?
    let attributeGroupId: String
    let attributeGroupName: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case valueId = "value_id"
        case valueName = "value_name"
        case attributeGroupId = "attribute_group_id"
        case attributeGroupName = "attribute_group_name"
    }
}

struct Description: Codable {
    let id: String
    let plainText: String?
    let lastUpdated: Date?
    
    enum CodingKeys: String, CodingKey {
        case id
        case plainText = "plain_text"
        case lastUpdated = "last_updated"
    }
}

// MARK: - Equatable
extension ItemDetail: Equatable {
    static func == (lhs: ItemDetail, rhs: ItemDetail) -> Bool {
        return lhs.id == rhs.id
    }
}

// MARK: - Mock Data
extension ItemDetail {
    static var mock: ItemDetail {
        return ItemDetail(
            id: "MLA123456789",
            title: "iPhone 13 Pro Max 256GB Plata Liberado",
            price: 1499.99,
            currencyId: "ARS",
            pictures: [
                Picture(
                    id: "123",
                    url: "https://http2.mlstatic.com/D_Q_NP_123456-MLA123456789_123456-O.webp",
                    secureUrl: "https://http2.mlstatic.com/D_Q_NP_123456-MLA123456789_123456-O.webp"
                ),
                Picture(
                    id: "124",
                    url: "https://http2.mlstatic.com/D_Q_NP_123456-MLA123456789_123456-O.webp",
                    secureUrl: "https://http2.mlstatic.com/D_Q_NP_123456-MLA123456789_123456-O.webp"
                )
            ],
            condition: "new",
            soldQuantity: 150,
            availableQuantity: 10,
            warranty: "12 meses",
            attributes: [
                Attribute(
                    id: "BRAND",
                    name: "Marca",
                    valueId: "9344",
                    valueName: "Apple",
                    attributeGroupId: "OTHERS",
                    attributeGroupName: "Otros"
                )
            ],
            descriptions: [
                Description(
                    id: "MLA123456789",
                    plainText: "iPhone 13 Pro Max 256GB en color Plata, liberado para todas las operadoras.",
                    lastUpdated: Date()
                )
            ]
        )
    }
}
