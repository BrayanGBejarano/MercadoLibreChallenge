//
//  SearchViewModel.swift
//  MercadoLibreChallenge
//
//  Created by Brayan Bejarano on 24/04/25.
//
import Foundation

protocol SearchViewModelProtocol {
    var isLoading: Observable<Bool> { get }
    var error: Observable<Error?> { get }
    var shouldNavigateToResults: Observable<String?> { get }
    func search(query: String)
}

class SearchViewModel: SearchViewModelProtocol {
    
    // MARK: - Properties
    private let apiClient: MELIAPIClientProtocol
    let isLoading = Observable<Bool>(false)
    let error = Observable<Error?>(nil)
    let shouldNavigateToResults = Observable<String?>(nil)
    private var currentRequest: (() -> Void)?
    
    // MARK: - Initialization
    init(apiClient: MELIAPIClientProtocol = MockAPIClient()) {
        self.apiClient = apiClient
    }
    
    // MARK: - Methods
    func search(query: String) {
        isLoading.value = true
        currentRequest = { [weak self] in
            self?.apiClient.searchItems(query: query) { result in
                self?.isLoading.value = false
                switch result {
                case .success:
                    self?.shouldNavigateToResults.value = query
                case .failure(let error):
                    print("ViewModel recibió error:", error)
                    self?.error.value = error
                }
            }
        }
        currentRequest?()
    }
}
