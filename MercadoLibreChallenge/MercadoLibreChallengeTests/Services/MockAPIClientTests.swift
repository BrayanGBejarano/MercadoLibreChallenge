//
//  MockAPIClientTests.swift
//  MercadoLibreChallengeTests
//
//  Created by Brayan Bejarano on 27/04/25.
//

import XCTest
@testable import MercadoLibreChallenge

class MockAPIClientTests: XCTestCase {
    var mockAPIClient: MockAPIClient!
    
    override func setUp() {
        super.setUp()
        mockAPIClient = MockAPIClient()
    }
    
    func testSearchItems() {
        let expectation = XCTestExpectation(description: "Search items")
        let mockItems = [TestHelpers.createMockItem()]
        mockAPIClient.searchItemsResult = .success(mockItems)
        
        mockAPIClient.searchItems(query: "test") { result in
            switch result {
            case .success(let items):
                XCTAssertEqual(items.count, 1)
            case .failure:
                XCTFail("Should not fail")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testGetItemDetails() {
        let expectation = XCTestExpectation(description: "Get item details")
        let mockDetail = TestHelpers.createMockItemDetail()
        mockAPIClient.getItemDetailsResult = .success(mockDetail)
        
        mockAPIClient.getItemDetails(id: "MLA1") { result in
            switch result {
            case .success(let detail):
                XCTAssertEqual(detail.id, "MLA1")
            case .failure:
                XCTFail("Should not fail")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
}
