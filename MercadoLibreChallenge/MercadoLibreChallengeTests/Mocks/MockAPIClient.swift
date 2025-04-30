//
//  MockAPIClient.swift
//  MercadoLibreChallengeTests
//
//  Created by Brayan Bejarano on 27/04/25.
//

// MercadoLibreChallengeTests/Mocks/MockAPIClient.swift

import Foundation
@testable import MercadoLibreChallenge

class MockAPIClient: MELIAPIClientProtocol {
    var searchItemsResult: Result<[Item], APIError> = .success([])
    var getItemDetailsResult: Result<ItemDetail, APIError> = .failure(.noData)
    var lastSearchQuery: String?
    var lastItemIdRequested: String?
    var simulateAsyncDelay = true
    var onSearchItemsCompleted: (() -> Void)?
    var shouldExecuteCompletionImmediately = true
    
    func searchItems(query: String, completion: @escaping (Result<[Item], APIError>) -> Void) {
        lastSearchQuery = query
        if shouldExecuteCompletionImmediately {
            DispatchQueue.main.async {
                completion(self.searchItemsResult)
            }
        }
    }
    
    func getItemDetails(id: String, completion: @escaping (Result<ItemDetail, APIError>) -> Void) {
        lastItemIdRequested = id
        if shouldExecuteCompletionImmediately {
            completion(getItemDetailsResult)
        }
    }
    
    // Métodos de conveniencia
    func setupSearchSuccess(items: [Item] = [TestHelpers.createMockItem()]) {
        searchItemsResult = .success(items)
    }
    
    func setupSearchFailure(error: APIError = .invalidURL) {
        searchItemsResult = .failure(error)
    }
    
    func setupItemDetailsSuccess(item: ItemDetail = TestHelpers.createMockItemDetail()) {
        getItemDetailsResult = .success(item)
    }
    
    func setupItemDetailsFailure(error: APIError = .itemNotFound) {
        getItemDetailsResult = .failure(error)
    }
}
