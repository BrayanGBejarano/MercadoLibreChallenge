//
//  MELIAPIClientTests.swift
//  MercadoLibreChallengeTests
//
//  Created by Brayan Bejarano on 27/04/25.
//

import XCTest
@testable import MercadoLibreChallenge

class MELIAPIClientTests: XCTestCase {
    var apiClient: MELIAPIClient!
    var mockURLSession: MockURLSession!
}

class MockURLSession: URLSession {
    var mockData: Data?
    var mockError: Error?
    var mockResponse: URLResponse?
    
    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let task = MockURLSessionDataTask()
        task.completionHandler = {
            completionHandler(self.mockData, self.mockResponse, self.mockError)
        }
        return task
    }
}

class MockURLSessionDataTask: URLSessionDataTask {
    var completionHandler: (() -> Void)?
    
    override func resume() {
        completionHandler?()
    }
}
