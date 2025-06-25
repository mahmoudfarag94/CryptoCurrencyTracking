//
//  CryptoRepositoryTests.swift
//  CryptoTrackingTests
//
//  Created by Mahmoud Farag on 27/12/2024.
//

import Foundation


import XCTest
import Combine
@testable import CryptoTracking
import XCTest

final class CryptoRepositoryTests: XCTestCase {
    
    var sut: CryptoRepositoryImpl!
    var networkService: NetworkServiceMock!
    var networkMonitor: NetworkMonitorMock!
    var errorManager: ErrorManagerMock!
    var localDatabaseService: LocalDatabaseServiceMock!
    
    override func setUp() {
        super.setUp()
        
        networkService = NetworkServiceMock()
        networkMonitor = NetworkMonitorMock()
        errorManager = ErrorManagerMock()
        localDatabaseService = LocalDatabaseServiceMock()
        
        sut = CryptoRepositoryImpl(
            networkService: networkService,
            networkMonitor: networkMonitor,
            errorManager: ErrorManager.shared,
            databaseService: localDatabaseService
        )
    }
    
    override func tearDown() {
        sut = nil
        networkService = nil
        networkMonitor = nil
        errorManager = nil
        localDatabaseService = nil
        super.tearDown()
    }

//
//    // MARK: - ErrorManager Tests
//
    func test_showError_shouldUpdateCurrentError() {
        // Given
        let errorMessage = "An error occurred"
        
        // When
        errorManager.showError(errorMessage)

        // Then
        XCTAssertEqual(errorManager.currentError, errorMessage)
    }
//
    func test_clearError_shouldClearCurrentError() {
        // Given
        errorManager.showError("Some error")
        
        // When
       errorManager.clearError()

        // Then
        XCTAssertNil(errorManager.currentError)
    }
//
//    // MARK: - Network Connectivity Tests

//    
    func test_checkInternetConnection_whenOnline_shouldReturnTrue() {
        // Given
        networkMonitor.isConnected = true
        
        // When
        let result = sut.checkInternetConnection()
        
        // Then
        XCTAssertTrue(result)
        XCTAssertFalse(errorManager.didCallShowError)
    }
//    
//    // MARK: - Repository Fetching Tests
//    
    func test_fetchPrices_whenOnlineAndSuccess_shouldReturnMergedList() async {
        // Given
        localDatabaseService.fetchAllFavoritesReturnValue = [sampleCryptos.first!]
        
        networkService.mockResult = .success(sampleCryptos)
        
        // When
        let result = await sut.fetchPrices()
        
        // Then
        switch result {
        case .success(let cryptos):
            XCTAssertEqual(cryptos.count, 2)
            XCTAssertTrue(cryptos.first!.isFavorite ?? false) // BTC should be a favorite
        case .failure:
            XCTFail("Expected success, but got failure")
        }
    }
    
    func test_fetchPrices_whenOffline_shouldReturnFailure() async {
        // Given
        networkMonitor.isConnected = false
        
        // When
        let result = await sut.fetchPrices()
        
        // Then
        switch result {
        case .success:
            XCTFail("Expected failure, but got success")
        case .failure(let error):
            XCTAssertEqual(error, .offline)
        }
    }
    
    func test_fetchPrices_whenDecodingFailed_shouldReturnFailure() async {
        // Given
        networkService.mockResult = .failure(.decodingFailed)
        
        // When
        let result = await sut.fetchPrices()
        
        // Then
        switch result {
        case .success:
            XCTFail("Expected failure, but got success")
        case .failure(let error):
            XCTAssertEqual(error, .decodingFailed)
        }
    }
}


// LocalDatabaseService Mock
class LocalDatabaseServiceMock: LocalDatabaseService {
    var toggleFavoriteCalled = false
    var isFavoriteCalled = false
    var fetchAllFavoritesCalled = false
    
    var fetchAllFavoritesReturnValue: [Cryptocurrency] = []
    
    func toggleFavorite(crypto: Cryptocurrency) {
        toggleFavoriteCalled = true
    }

    func isFavorite(crypto: Cryptocurrency) -> Bool {
        isFavoriteCalled = true
        return fetchAllFavoritesReturnValue.contains { $0.symbol == crypto.symbol }
    }
    
    func fetchAllFavorites() -> [Cryptocurrency] {
        fetchAllFavoritesCalled = true
        return fetchAllFavoritesReturnValue
    }
}

