//
//  ProductDetailViewModel.swift
//  MercadoLibreChallenge
//
//  Created by Brayan Bejarano on 24/04/25.
//

import Foundation

protocol ProductDetailViewModelProtocol {
    var product: Observable<ItemDetail?> { get }
    var isLoading: Observable<Bool> { get }
    var error: Observable<Error?> { get }
    func fetchProductDetails()
}

class ProductDetailViewModel: ProductDetailViewModelProtocol {
    
    // MARK: - Properties
    private let apiClient: MELIAPIClientProtocol
    let itemId: String
    
    let product = Observable<ItemDetail?>(nil)
    let isLoading = Observable<Bool>(false)
    let error = Observable<Error?>(nil)
    
    // MARK: - Initialization
    init(itemId: String, apiClient: MELIAPIClientProtocol = MockAPIClient()) {
        self.itemId = itemId
        self.apiClient = apiClient
    }		
    
    // MARK: - Methods
    func fetchProductDetails() {
        isLoading.value = true
        
        apiClient.getItemDetails(id: itemId) { [weak self] result in
            guard let self = self else { return }
            self.isLoading.value = false
            
            switch result {
            case .success(let product):
                self.product.value = product
            case .failure(let error):
                self.error.value = error
            }
        }
    }
}
