//
//  RealTimePricesViewModelTests.swift
//  CryptoTrackingTests
//
//  Created by Mahmoud Farag on 27/12/2024.
//

import XCTest
import Combine
@testable import CryptoTracking

final class RealTimePricesViewModelTests: XCTestCase {
    private var sut: RealTimePricesViewModel!
    private var mockFetchUseCase: MockFetchPricesUseCase!
    private var cancellables: Set<AnyCancellable>! = Set<AnyCancellable>()
    
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        sut = nil
        mockFetchUseCase = nil
        cancellables = nil
        super.tearDown()
    }

    func test_autoRefresh_whenTimerTriggers_shouldCallFetchData() async {
        // Given
        let result: MockResult = .success(sampleCryptos)
        let exp = expectation(description: #function)

        createSut(result: result)
        
        // Observe the `fetchData` call via a callback, to confirm it was triggered by the timer.
        sut.$state.sink { state in
            if state == .success(sampleCryptos) {
                exp.fulfill()
            }
        }.store(in: &cancellables)
        
        await fulfillment(of: [exp], timeout: 1)
        
        // Then
        XCTAssertEqual(sut.state, .success(sampleCryptos))
    }

    func test_timer_WhenViewModelIsDeinitialized_shouldCancelTimer() async {
        // Given
        let result: MockResult = .success(sampleCryptos)
        let exp = expectation(description: #function)

        createSut(result: result)
        
        // Attach a timer observer to ensure the timer cancellable is not retained once the view model is deinitialized.
        sut.$state.sink { state in
            if state == .success(sampleCryptos) {
                exp.fulfill()
            }
        }.store(in: &cancellables)
        
        // When
        sut = nil  // Deinit the view model
        
        // Then
        await fulfillment(of: [exp], timeout: 1)
        XCTAssertNil(sut?.timerCancellable)
    }
    
    func test_lastUpdate_whenAutoRefreshShouldUpdate() async {
         // Given
         let result: MockResult = .success(sampleCryptos)
         let exp = expectation(description: #function)

         // Use a custom timer interval for the test to speed up the execution
         createSut(result: result, timerInterval: 5) // 1 second for testing
         let previousLastUpdate = sut.lastUpdate
         
         sut.$state.sink {[weak self] state in
             if state == .success(sampleCryptos), previousLastUpdate != self?.sut.lastUpdate {
                 exp.fulfill()
             }
         }.store(in: &cancellables)


         await fulfillment(of: [exp], timeout: 10)
         
         // Then
         XCTAssertGreaterThan(self.sut.lastUpdate, previousLastUpdate, "The lastUpdate should have been updated after the auto-refresh trigger")
     }
    
    // Helper to initialize the ViewModel
    func createSut(result: MockResult = .success(sampleCryptos), timerInterval: TimeInterval = 30.0 ) {
        mockFetchUseCase = MockFetchPricesUseCase()
        mockFetchUseCase.result = result
        sut = RealTimePricesViewModel(fetchUseCase: mockFetchUseCase,timerInterval: timerInterval)
    }
}
