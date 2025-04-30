//
//  SuggestionServiceTests.swift
//  MercadoLibreChallengeTests
//
//  Created by Brayan Bejarano on 27/04/25.
//

import XCTest
@testable import MercadoLibreChallenge

class SuggestionServiceTests: XCTestCase {
    var service: SuggestionService!
    
    override func setUp() {
        super.setUp()
        service = SuggestionService()
    }
    
    func testFetchPopularProducts() {
        let expectation = XCTestExpectation(description: "Fetch products")
        
        service.fetchPopularProducts { result in
            switch result {
            case .success(let products):
                XCTAssertFalse(products.isEmpty)
                XCTAssertEqual(products.first?.id, "MLA1")
            case .failure:
                XCTFail("Should not fail")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
}
