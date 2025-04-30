//
//  TestHelpers.swift
//  MercadoLibreChallengeTests
//
//  Created by Brayan Bejarano on 27/04/25.
//

import Foundation
@testable import MercadoLibreChallenge

enum MockError: Error {
    case simulatedError
}

class TestHelpers {
    static func createMockItem(id: String = "MLA1",
                             title: String = "Test Item",
                             price: Double = 100.0,
                             thumbnail: String = "https://test.com/img.jpg",
                             condition: String = "new",
                             availableQuantity: Int = 10,
                             soldQuantity: Int = 5,
                             acceptsMercadopago: Bool = true) -> Item {
        return Item(
            id: id,
            title: title,
            price: price,
            thumbnail: thumbnail,
            condition: condition,
            availableQuantity: availableQuantity,
            soldQuantity: soldQuantity,
            acceptsMercadopago: acceptsMercadopago
        )
    }
    
    static func createMockItemDetail(id: String = "MLA1",
                                   title: String = "Test Item Detail",
                                   price: Double = 100.0,
                                   currencyId: String = "USD",
                                   thumbnail: String = "https://test.com/img.jpg") -> ItemDetail {
        return ItemDetail(
            id: id,
            title: title,
            price: price,
            currencyId: currencyId,
            pictures: [Picture(id: "1", url: thumbnail, secureUrl: thumbnail)],
            condition: "new",
            soldQuantity: 5,
            availableQuantity: 10,
            warranty: "1 year",
            attributes: [],
            descriptions: []
        )
    }
    
    static func createMockSuggestedProduct() -> SuggestedProduct {
        return SuggestedProduct(
            id: "MLA1",
            title: "Test Product",
            price: 100.0,
            thumbnail: "https://test.com/img1.jpg",
            isPopular: true
        )
    }
}
