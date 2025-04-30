//
//  ResultsViewModel.swift
//  MercadoLibreChallenge
//
//  Created by Brayan Bejarano on 24/04/25.
//

final class ResultsViewModel {
    
    // MARK: - Properties
    private(set) var items: [Item] = []
    let itemsObservable = Observable<[Item]>([])
    let isLoading = Observable<Bool>(false)
    let error = Observable<Error?>(nil)
    let showEmptyState = Observable<Bool>(false) // Nuevo observable
    
    private let apiClient: MELIAPIClientProtocol
    let query: String
    
    // MARK: - Initialization
    init(query: String, apiClient: MELIAPIClientProtocol = MockAPIClient()) {
        self.query = query
        self.apiClient = apiClient
        performSearch()
    }
    
    // MARK: - Public Methods
    func performSearch() {
        isLoading.value = true
        showEmptyState.value = false
        
        apiClient.searchItems(query: query) { [weak self] result in
            guard let self = self else { return }
            self.isLoading.value = false
            
            switch result {
            case .success(let items):
                self.items = items
                self.itemsObservable.value = items
                self.showEmptyState.value = items.isEmpty
            case .failure(let error):
                self.error.value = error
            }
        }
    }
    
    func retryLastSearch() {
        performSearch()
    }
}
