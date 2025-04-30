//
//  ResultsViewModelEdgeCasesTests.swift
//  MercadoLibreChallengeTests
//
//  Created by Brayan Bejarano on 28/04/25.
//

import XCTest
@testable import MercadoLibreChallenge

class ResultsViewModelEdgeCasesTests: XCTestCase {
    
    var mockAPIClient: MockAPIClient!
    var viewModel: ResultsViewModel!
    
    override func setUp() {
        super.setUp()
        mockAPIClient = MockAPIClient()
        mockAPIClient.shouldExecuteCompletionImmediately = true
    }
    
    func testEmptySearchQuery() {
        viewModel = ResultsViewModel(query: "", apiClient: mockAPIClient)
        
        let expectation = XCTestExpectation(description: "Should show empty state")
        
        viewModel.showEmptyState.bind { show in
            if show {
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(viewModel.items.isEmpty)
    }
    
    func testNetworkErrorRecovery() {
        mockAPIClient.setupSearchFailure(error: .noData)
        viewModel = ResultsViewModel(query: "test", apiClient: mockAPIClient)
        
        let errorExpectation = XCTestExpectation(description: "Error received")
        viewModel.error.bind { error in
            if error != nil {
                errorExpectation.fulfill()
            }
        }
        wait(for: [errorExpectation], timeout: 1.0)
        
        // Simular reintento exitoso
        mockAPIClient.setupSearchSuccess(items: [TestHelpers.createMockItem()])
        let successExpectation = XCTestExpectation(description: "Retry success")
        viewModel.itemsObservable.bind { items in
            if !items.isEmpty {
                successExpectation.fulfill()
            }
        }
        viewModel.retryLastSearch()
        wait(for: [successExpectation], timeout: 1.0)
    }
}
