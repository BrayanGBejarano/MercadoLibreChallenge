//
//  ResultsViewModelTests.swift
//  MercadoLibreChallengeTests
//
//  Created by Brayan Bejarano on 27/04/25.
//

import XCTest
@testable import MercadoLibreChallenge

class ResultsViewModelTests: XCTestCase {
    var viewModel: ResultsViewModel!
    var mockAPIClient: MockAPIClient!
    
    override func setUp() {
        super.setUp()
        mockAPIClient = MockAPIClient()
        viewModel = ResultsViewModel(query: "test", apiClient: mockAPIClient)
    }
    
    func testInitialState() {
        XCTAssertEqual(viewModel.query, "test")
        XCTAssertTrue(viewModel.items.isEmpty)
    }
    
    func testPerformSearchSuccess() {
        let expectation = XCTestExpectation(description: "Search success")
        let mockItems = [TestHelpers.createMockItem(id: "MLA1"), TestHelpers.createMockItem(id: "MLA2")]
        mockAPIClient.searchItemsResult = .success(mockItems)
        
        viewModel.itemsObservable.bind { items in
            if !items.isEmpty {
                XCTAssertEqual(items.count, 2)
                expectation.fulfill()
            }
        }
        
        viewModel.performSearch()
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testShowEmptyState() {
        let expectation = XCTestExpectation(description: "Empty state")
        mockAPIClient.searchItemsResult = .success([])
        
        viewModel.showEmptyState.bind { show in
            if show {
                expectation.fulfill()
            }
        }
        
        viewModel.performSearch()
        wait(for: [expectation], timeout: 1.0)
    }
}
