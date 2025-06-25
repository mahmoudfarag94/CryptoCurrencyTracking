//
//  FavoritesViewModelTests.swift
//  CryptoTrackingTests
//
//  Created by Mahmoud Farag on 27/12/2024.
//

import Foundation

import XCTest
import Combine
@testable import CryptoTracking

// Mock FavoritesRepository
class MockFavoritesRepository: FavoritesRepository {
    var isFavoriteChangedCalled = false
    
    func changeFavorite(symbol: String, isFavorite: Bool) {
        isFavoriteChangedCalled = true
    }
}

final class FavoritesViewModelTests: XCTestCase {
    
    private var sut: FavoritesViewModel!
    private var mockFetchUseCase: MockFetchPricesUseCase!
    private var mockFavoritesRepository: MockFavoritesRepository!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        sut = nil
        mockFavoritesRepository = nil
        cancellables = nil
        super.tearDown()
    }
    
    func test_onChange_shouldTriggerFetchData() async {
        
        // Given
        let expectation1 = expectation(description: "First Fetch")
        let expectation2 = expectation(description: "Fetch From onChange")
        
        var fulfillCount = 0
        mockFetchUseCase = MockFetchPricesUseCase()
        mockFetchUseCase.result = .success(sampleCryptos)
        sut = FavoritesViewModel(fetchUseCase: mockFetchUseCase)
        // when
        sut.$state.sink { state in
            if state ==  .success(sampleCryptos) {
                fulfillCount += 1
                if fulfillCount == 1 {
                    expectation1.fulfill() // First expectation fulfilled
                }
                if fulfillCount == 2 {
                    expectation2.fulfill() // Second expectation fulfilled
                }
            }
        }.store(in: &cancellables)
        
        // when
        sut.onChange(symbol: "BTC", isFavorite: true)
        
        await fulfillment(of: [expectation1, expectation2], timeout: 2)
        // Then
        XCTAssertEqual(sut.state, .success(sampleCryptos))
    }
}
