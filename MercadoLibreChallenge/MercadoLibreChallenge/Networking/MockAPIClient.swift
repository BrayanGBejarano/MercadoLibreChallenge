//
//  MockAPIClient.swift
//  MercadoLibreChallenge
//
//  Created by Brayan Bejarano on 26/04/25.
//

import Foundation

final class MockAPIClient: MELIAPIClientProtocol {
    var lastSearchQuery: String?

    // MARK: - Mock Data
    private var mockItems: [Item] = [
        Item(
            id: "MLA1",
            title: "iPhone 13 Pro Max 256GB Plata Liberado",
            price: 1499.99,
            thumbnail: "https://http2.mlstatic.com/D_Q_NP_123456-MLA123456789_123456-O.webp",
            condition: "new",
            availableQuantity: 10,
            soldQuantity: 150,
            acceptsMercadopago: true
        ),
        Item(
            id: "MLA2",
            title: "iPhone 12 64GB Negro",
            price: 254.99,
            thumbnail: "https://http2.mlstatic.com/D_Q_NP_123456-MLA123456789_123456-O.webp",
            condition: "new",
            availableQuantity: 10,
            soldQuantity: 150,
            acceptsMercadopago: true
        ),
        Item(
            id: "MLA3",
            title: "iPhone 12 Mini 128GB Azul",
            price: 233.29,
            thumbnail: "https://http2.mlstatic.com/D_Q_NP_123456-MLA123456789_123456-O.webp",
            condition: "new",
            availableQuantity: 10,
            soldQuantity: 150,
            acceptsMercadopago: true
        ),
        Item(
            id: "MLA4",
            title: "iPhone 12 Pro Max 128GB Grafito",
            price: 307.33,
            thumbnail: "https://http2.mlstatic.com/D_Q_NP_123456-MLA123456789_123456-O.webp",
            condition: "new",
            availableQuantity: 10,
            soldQuantity: 150,
            acceptsMercadopago: true
        ),
        Item(
            id: "MLA5",
            title: "iPhone 11 64GB Negro",
            price: 230.72,
            thumbnail: "https://http2.mlstatic.com/D_Q_NP_123456-MLA123456789_123456-O.webp",
            condition: "new",
            availableQuantity: 10,
            soldQuantity: 150,
            acceptsMercadopago: true
        ),
        Item(
            id: "MLA6",
            title: "iPhone 11 Pro 256GB verde",
            price: 333.27,
            thumbnail: "https://http2.mlstatic.com/D_Q_NP_123456-MLA123456789_123456-O.webp",
            condition: "new",
            availableQuantity: 10,
            soldQuantity: 150,
            acceptsMercadopago: true
        ),
        Item(
            id: "MLA7",
            title: "Samsung Galaxy S22 Ultra 256GB Negro",
            price: 1299.99,
            thumbnail: "https://http2.mlstatic.com/D_Q_NP_123456-MLA987654321_123456-O.webp",
            condition: "new",
            availableQuantity: 15,
            soldQuantity: 85,
            acceptsMercadopago: true
        ),
        Item(
            id: "MLA8",
            title: "Notebook Dell Inspiron 15 3520 i5 8GB 256GB SSD",
            price: 899.99,
            thumbnail: "https://http2.mlstatic.com/D_Q_NP_123456-MLA567891234_123456-O.webp",
            condition: "new",
            availableQuantity: 8,
            soldQuantity: 42,
            acceptsMercadopago: true
        ),
        Item(
            id: "MLA9",
            title: "Smart TV LG 55\" 4K UHD AI ThinQ",
            price: 799.99,
            thumbnail: "https://http2.mlstatic.com/D_Q_NP_123456-MLA432156789_123456-O.webp",
            condition: "new",
            availableQuantity: 12,
            soldQuantity: 63,
            acceptsMercadopago: true
        ),
        Item(
            id: "MLA10",
            title: "Cámara Canon EOS Rebel T7 + Lente 18-55mm",
            price: 599.99,
            thumbnail: "https://http2.mlstatic.com/D_Q_NP_123456-MLA876543219_123456-O.webp",
            condition: "new",
            availableQuantity: 5,
            soldQuantity: 28,
            acceptsMercadopago: true
        ),
        Item(
            id: "MLA11",
            title: "PlayStation 5 825GB Standard - Blanco",
            price: 999.99,
            thumbnail: "https://http2.mlstatic.com/D_Q_NP_123456-MLA345678912_123456-O.webp",
            condition: "new",
            availableQuantity: 7,
            soldQuantity: 112,
            acceptsMercadopago: true
        ),
        Item(
            id: "MLA12",
            title: "Auriculares Sony WH-1000XM4 - Negro",
            price: 349.99,
            thumbnail: "https://http2.mlstatic.com/D_Q_NP_123456-MLA789123456_123456-O.webp",
            condition: "new",
            availableQuantity: 20,
            soldQuantity: 75,
            acceptsMercadopago: true
        ),
        Item(
            id: "MLA13",
            title: "Apple Watch Series 8 GPS 41mm - Medianoche",
            price: 449.99,
            thumbnail: "https://http2.mlstatic.com/D_Q_NP_123456-MLA654321987_123456-O.webp",
            condition: "new",
            availableQuantity: 9,
            soldQuantity: 38,
            acceptsMercadopago: true
        ),
        Item(
            id: "MLA14",
            title: "Xiaomi Redmi Note 11 Pro 128GB - Gris",
            price: 299.99,
            thumbnail: "https://http2.mlstatic.com/D_Q_NP_123456-MLA912345678_123456-O.webp",
            condition: "new",
            availableQuantity: 25,
            soldQuantity: 94,
            acceptsMercadopago: true
        ),
        Item(
            id: "MLA15",
            title: "Nintendo Switch OLED 64GB - Blanco",
            price: 499.99,
            thumbnail: "https://http2.mlstatic.com/D_Q_NP_123456-MLA219876543_123456-O.webp",
            condition: "new",
            availableQuantity: 6,
            soldQuantity: 47,
            acceptsMercadopago: true
        )
    ]
    
    // MARK: - Public Methods
    func searchItems(query: String, completion: @escaping (Result<[Item], APIError>) -> Void) {
        lastSearchQuery = query
        print("MockAPIClient recibió query:", query)
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
            if query.isEmpty {
                completion(.success(self.mockItems))
            } else {
                let filteredItems = self.mockItems.filter {
                    $0.title.lowercased().contains(query.lowercased())
                }
                completion(.success(filteredItems))
            }
        }
    }
    
    func getItemDetails(id: String, completion: @escaping (Result<ItemDetail, APIError>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
            guard let item = self.mockItems.first(where: { $0.id == id }) else {
                completion(.failure(.itemNotFound))
                return
            }
            
            let detail = ItemDetail(
                id: item.id,
                title: item.title,
                price: item.price,
                currencyId: "ARS",
                pictures: [
                    Picture(
                        id: "\(item.id)-1",
                        url: item.thumbnail,
                        secureUrl: item.thumbnail
                    ),
                    Picture(
                        id: "\(item.id)-2",
                        url: item.thumbnail.replacingOccurrences(of: "-O.webp", with: "-F.webp"),
                        secureUrl: item.thumbnail.replacingOccurrences(of: "-O.webp", with: "-F.webp")
                    )
                ],
                condition: item.condition,
                soldQuantity: item.soldQuantity,
                availableQuantity: item.availableQuantity,
                warranty: "12 meses",
                attributes: [
                    Attribute(
                        id: "BRAND",
                        name: "Marca",
                        valueId: nil,
                        valueName: item.title.components(separatedBy: " ").first,
                        attributeGroupId: "OTHERS",
                        attributeGroupName: "Otros"
                    ),
                    Attribute(
                        id: "MODEL",
                        name: "Modelo",
                        valueId: nil,
                        valueName: item.title.components(separatedBy: " ").dropFirst().first,
                        attributeGroupId: "OTHERS",
                        attributeGroupName: "Otros"
                    )
                ],
                descriptions: [
                    Description(
                        id: item.id,
                        plainText: "Descripción detallada del producto \(item.title).\n\nCaracterísticas principales:\n- Producto en condición \(item.conditionDisplay)\n- \(item.availableQuantity) unidades disponibles\n- \(item.soldQuantity) vendidos",
                        lastUpdated: Date()
                    )
                ]
            )
            
            completion(.success(detail))
        }
    }
}
