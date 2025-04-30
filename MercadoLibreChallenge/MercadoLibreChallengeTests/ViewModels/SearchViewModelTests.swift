//
//  SearchViewModelTests.swift
//  MercadoLibreChallengeTests
//
//  Created by Brayan Bejarano on 27/04/25.
//

import XCTest
@testable import MercadoLibreChallenge

class SearchViewModelTests: XCTestCase {
    var viewModel: SearchViewModel!
    var mockAPIClient: MockAPIClient!
    
    override func setUp() {
        super.setUp()
        mockAPIClient = MockAPIClient()
        viewModel = SearchViewModel(apiClient: mockAPIClient)
    }
    
    override func tearDown() {
        viewModel = nil
        mockAPIClient = nil
        super.tearDown()
    }
    
    func testSearchSuccess() {
        
        // 1. Configuración
        let mockAPIClient = MockAPIClient()
        let expectedQuery = "iphone"
        mockAPIClient.searchItemsResult = .success([TestHelpers.createMockItem()])
        
        let viewModel = SearchViewModel(apiClient: mockAPIClient)
        let expectation = XCTestExpectation(description: "Navigation triggered")
        
        // 2. Variables para controlar el estado
        var receivedValues = [String?]()
        
        // 3. Prueba
        viewModel.shouldNavigateToResults.bind { query in
            receivedValues.append(query)
            
            // Solo se verifica el último valor no-nil
            if let query = query {
                XCTAssertEqual(query, expectedQuery)
                XCTAssertEqual(mockAPIClient.lastSearchQuery, expectedQuery)
                expectation.fulfill()
            }
        }
        
        // 4. Ejecución
        viewModel.search(query: expectedQuery)
        
        // 5. Verificación
        wait(for: [expectation], timeout: 1.0)
    
        print("Valores recibidos en el binding:", receivedValues)
    }
    
    func testSearchFailureWithAPIError() {
        // 1. Configuración
        let mockAPIClient = MockAPIClient()
        let expectedError = APIError.invalidURL
        mockAPIClient.searchItemsResult = .failure(expectedError)
        
        let viewModel = SearchViewModel(apiClient: mockAPIClient)
        let expectation = XCTestExpectation(description: "Error received")
        
        // 2. Prueba
        viewModel.error.bind { error in
            guard let error = error else { return }
            
            XCTAssertEqual(error as? APIError, expectedError)
            expectation.fulfill()
        }
        
        // 3. Ejecución
        viewModel.search(query: "test")
        
        // 4. Verificación
        wait(for: [expectation], timeout: 1.0)
        
        // Verificaciones adicionales
        XCTAssertEqual(mockAPIClient.lastSearchQuery, "test")
    }
    
    func testSearchLoadingState() {
        
        // 1. Configuración
        let expectation = XCTestExpectation(description: "Loading state")
        var loadingStates = [Bool]()
        
        //2. Prueba
        viewModel.isLoading.bind { isLoading in
            loadingStates.append(isLoading)
            if loadingStates.count == 2 { // Initial + change
                XCTAssertEqual(loadingStates, [false, true])
                expectation.fulfill()
            }
        }
        
        viewModel.search(query: "test")
        
        //3. Verificación
        wait(for: [expectation], timeout: 2.0)
    }
}
