//
//  CryptoSearchViewModelTests.swift
//  CryptoTrackingTests
//
//  Created by Mahmoud Farag on 27/12/2024.
//

import XCTest
import Combine
@testable import CryptoTracking

final class CryptoSearchViewModelTests: XCTestCase {
    private var sut: CryptoSearchViewModel!
    private var mockFetchUseCase: MockFetchPricesUseCase!
    private var cancellables:Set<AnyCancellable>! = Set<AnyCancellable>()

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        sut = nil
        mockFetchUseCase = nil
        super.tearDown()
        cancellables = nil

    }

    func test_searchText_withMatchingResults_shouldUpdateStateToFilteredResults() async {
        // Given
        let result: MockResult = .success(sampleCryptos)
        let exp = expectation(description: #function)

        createSut(result: result)
        
        sut.$state.sink { state in
            if state ==  .success(filteredCryptos) {
                exp.fulfill()
            }
        }.store(in: &cancellables)
        
        // When
        sut.searchText = "BTC"
        
        await fulfillment(of: [exp],timeout: 1)
        // Then
        XCTAssertEqual(sut.state, .success(filteredCryptos))
    }

    func test_searchText_withEmptyQuery_shouldReturnAllCryptos() async {
        // Given
        let result: MockResult = .success(sampleCryptos)
        let exp = expectation(description: #function)

        createSut(result: result)
        
        sut.$state.sink { state in
            if state ==  .success(sampleCryptos) {
                exp.fulfill()
            }
        }.store(in: &cancellables)
        
        // When
        sut.searchText = ""
        
        await fulfillment(of: [exp],timeout: 1)
        // Then
        XCTAssertEqual(sut.state, .success(sampleCryptos))
    }

    func test_searchText_withNoMatchingResults_shouldReturnEmptyList() async {
        // Given
        let result: MockResult = .success(sampleCryptos)
        let exp = expectation(description: #function)

        createSut(result: result)
        
        sut.$state.sink { state in
            if state ==  .success([]) {
                exp.fulfill()
            }
        }.store(in: &cancellables)
        
        // When
        sut.searchText = "XPR"
        
        await fulfillment(of: [exp],timeout: 1)
        // Then
        XCTAssertEqual(sut.state, .success([]))
    }
//    
    func createSut(result: MockResult = .success(sampleCryptos))  {
        mockFetchUseCase = MockFetchPricesUseCase()
        mockFetchUseCase.result = result
        sut = CryptoSearchViewModel(fetchUseCase: mockFetchUseCase)
    }
}
