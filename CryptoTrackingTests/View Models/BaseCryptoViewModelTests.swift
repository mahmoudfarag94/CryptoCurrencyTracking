//
//  BaseCryptoViewModelTests.swift
//  CryptoTrackingTests
//
//  Created by Mahmoud Farag on 27/12/2024.
//

import Foundation


import XCTest
import Combine
@testable import CryptoTracking

final class BaseCryptoViewModelTests: XCTestCase {
    private var sut: BaseCryptoViewModel!
    private var mockFetchUseCase: MockFetchPricesUseCase!
    private var cancellables:Set<AnyCancellable>! = Set<AnyCancellable>()
    override func setUp() {
        super.setUp()
        
    }

    override func tearDown() {
        sut = nil
        mockFetchUseCase = nil
        cancellables = nil
        super.tearDown()
    }

    func test_fetchData_withSuccessResponse_shouldUpdateStateToSuccess() async {
        // Given
        let result: MockResult = .success(sampleCryptos)
        let exp = expectation(description: #function)

        // when
        createSut(result: result)
        sut.$state.sink { state in
            if state ==  .success(sampleCryptos) {
                exp.fulfill()
            }
        }.store(in: &cancellables)
        
        await fulfillment(of: [exp],timeout: 1)
        // Then
        XCTAssertEqual(sut.state, .success(sampleCryptos))
    }

    func test_fetchData_withErrorResponse_shouldUpdateStateToError() async {
        // Given
        let result: MockResult =  .failure(.decodingFailed)
        let exp = expectation(description: #function)
        
        // when
        createSut(result: result)
        sut.$state.sink { state in
            if state ==  .error(AppError.decodingFailed.errorDescription) {
                exp.fulfill()
            }
        }.store(in: &cancellables)
        
        await fulfillment(of: [exp],timeout: 1)
        // Then
        XCTAssertEqual(sut.state,  .error(AppError.decodingFailed.errorDescription))
    }

    func test_onChange_withNotification_shouldUpdateCryptoFavoriteStatus() async {
        // Given
        let result: MockResult = .success(sampleCryptos)
        let exp = expectation(description: #function)
        createSut(result: result)
        
        // when
        NotificationCenter.default.post(name: .CryptoChange, object: nil, userInfo: ["symbol": "BTC", "isFavorite": true])
       
        sut.$state.sink { state in
            if state == .success(favoriteCryptos) {
                exp.fulfill()
            }
        }.store(in: &cancellables)

        await fulfillment(of: [exp],timeout: 1)
        // Then
        XCTAssertEqual(sut.state, .success(favoriteCryptos))
    }
    
    func createSut(result: MockResult = .success(sampleCryptos))  {
        mockFetchUseCase = MockFetchPricesUseCase()
        mockFetchUseCase.result = result
        sut = BaseCryptoViewModel(fetchUseCase: mockFetchUseCase)
    }
}

