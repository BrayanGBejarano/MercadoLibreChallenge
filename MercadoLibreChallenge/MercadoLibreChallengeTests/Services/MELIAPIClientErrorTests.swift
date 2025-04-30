//
//  MELIAPIClientErrorTests.swift
//  MercadoLibreChallengeTests
//
//  Created by Brayan Bejarano on 28/04/25.
//

import XCTest
@testable import MercadoLibreChallenge

class MELIAPIClientErrorTests: XCTestCase {
    
    var mockURLSession: MockURLSession!
    var apiClient: MELIAPIClient!
    
    override func setUp() {
        super.setUp()
        mockURLSession = MockURLSession()
        apiClient = MELIAPIClient(urlSession: mockURLSession)
    }
    
    func testServerErrorResponse() {
        let json = """
        {
            "message": "Internal server error",
            "error": "server_error",
            "status": 500
        }
        """
        
        mockURLSession.mockData = json.data(using: .utf8)
        mockURLSession.mockResponse = HTTPURLResponse(
            url: URL(string: "https://api.mercadolibre.com")!,
            statusCode: 500,
            httpVersion: nil,
            headerFields: nil
        )
        
        let expectation = XCTestExpectation(description: "Server error response")
        
        apiClient.getItemDetails(id: "MLA1") { result in
            if case .failure(let error) = result {
                XCTAssertEqual(error as? APIError, .serverError(code: 500, message: "Internal server error"))
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testDecodingError() {
        let invalidJSON = """
        {"invalid": "data"}
        """
        
        mockURLSession.mockData = invalidJSON.data(using: .utf8)
        mockURLSession.mockResponse = HTTPURLResponse(
            url: URL(string: "https://api.mercadolibre.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        let expectation = XCTestExpectation(description: "Decoding error response")
        
        apiClient.searchItems(query: "test") { result in
            if case .failure(let error) = result {
                XCTAssertNotNil(error as? APIError)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
}
