//
//  ProductDetailViewModelTests.swift
//  MercadoLibreChallengeTests
//
//  Created by Brayan Bejarano on 27/04/25.
//

import XCTest
@testable import MercadoLibreChallenge

class ProductDetailViewModelTests: XCTestCase {
    var viewModel: ProductDetailViewModel!
    var mockAPIClient: MockAPIClient!
    
    override func setUp() {
        super.setUp()
        mockAPIClient = MockAPIClient()
        viewModel = ProductDetailViewModel(itemId: "MLA1", apiClient: mockAPIClient)
    }
    
    func testFetchProductSuccess() {
        //1. Configuración
        let mockDetail = TestHelpers.createMockItemDetail()
        mockAPIClient.setupItemDetailsSuccess(item: mockDetail)
        let expectation = XCTestExpectation(description: "Fetch success")
        
        //2. Prueba
        viewModel.product.bind { product in
            if product != nil {
                XCTAssertEqual(product?.id, "MLA1")
                expectation.fulfill()
            }
        }
        
        viewModel.fetchProductDetails()
        
        //3. Verificación
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchProductFailureWithAPIError() {
        // 1. Configuración
        let expectedError = APIError.itemNotFound
        mockAPIClient.setupItemDetailsFailure(error: expectedError)
        
        mockAPIClient.shouldExecuteCompletionImmediately = true
        
        let expectation = XCTestExpectation(description: "Fetch failure")
        
        // 2. Variables de seguimiento
        var errorReceived: Error?
        var bindingCalled = false
        
        // 3. Prueba
        viewModel.error.bind { error in
            bindingCalled = true
            errorReceived = error
            
            if let error = error {
                print("Error recibido en el binding:", error)
                XCTAssertEqual(error as? APIError, expectedError)
                expectation.fulfill()
            } else {
                print("Error recibido es nil")
            }
        }
        
        // 4. Ejecución
        viewModel.fetchProductDetails()
        
        // 5. Verificación
        wait(for: [expectation], timeout: 1.0)
        
        // Verificaciones adicionales
        XCTAssertTrue(bindingCalled, "El binding debería haberse ejecutado")
        XCTAssertNotNil(errorReceived, "El error no debería ser nil")
        
        // Debug
        print("Estado final:")
        print("- Binding ejecutado:", bindingCalled)
        print("- Error recibido:", errorReceived as Any)
        print("- Último ID solicitado:", mockAPIClient.lastItemIdRequested as Any)
    }
}
