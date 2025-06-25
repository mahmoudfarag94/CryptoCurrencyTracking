//
//  CoreDataServiceTests.swift
//  CryptoTrackingTests
//
//  Created by Mahmoud Farag on 27/12/2024.
//

import XCTest
import CoreData
@testable import CryptoTracking

final class CoreDataServiceTests: XCTestCase {
    var sut: CoreDataService!
    var notifier: MockNotifier!

    override func setUp() {
        super.setUp()
        // Use an in-memory Core Data stack for tests
        notifier = MockNotifier()
        sut = CoreDataService.createForTesting(notifier: notifier)
    }
    
    override func tearDown() {
        sut = nil
        notifier = nil
        super.tearDown()
    }

    // MARK: - Tests
    
    func test_toggleFavorite_withNewCrypto_shouldAddToFavorites() {
        // Given
        let crypto = Cryptocurrency(symbol: "BTC", price: "10000", time: 12345, dailyChange: "0.02", ts: 67890)

        // When
        sut.toggleFavorite(crypto: crypto)

        // Then
        let isFavorite = sut.isFavorite(crypto: crypto)
        XCTAssertTrue(isFavorite, "Crypto should be marked as favorite after toggle.")
        
        let favorites = sut.fetchAllFavorites()
        XCTAssertEqual(favorites.count, 1, "There should be 1 favorite in the list.")
        XCTAssertEqual(favorites.first?.symbol, crypto.symbol, "Favorite's symbol should match the toggled crypto's symbol.")
    }
    
    func test_toggleFavorite_withExistingCrypto_shouldRemoveFromFavorites() {
        // Given
        let crypto = Cryptocurrency(symbol: "BTC", price: "10000", time: 12345, dailyChange: "0.02", ts: 67890)
        sut.toggleFavorite(crypto: crypto) // Add to favorites first

        // When
        sut.toggleFavorite(crypto: crypto) // Toggle again to remove

        // Then
        let isFavorite = sut.isFavorite(crypto: crypto)
        XCTAssertFalse(isFavorite, "Crypto should not be marked as favorite after second toggle.")
        
        let favorites = sut.fetchAllFavorites()
        XCTAssertEqual(favorites.count, 0, "Favorites list should be empty after removing the crypto.")
    }
    
    func test_fetchAllFavorites_withMultipleCryptos_shouldReturnCorrectCount() {
        // Given
        let crypto1 = Cryptocurrency(symbol: "BTC", price: "10000", time: 12345, dailyChange: "0.02", ts: 67890)
        let crypto2 = Cryptocurrency(symbol: "ETH", price: "1500", time: 54321, dailyChange: "0.05", ts: 98765)
        
        sut.toggleFavorite(crypto: crypto1)
        sut.toggleFavorite(crypto: crypto2)

        // When
        let favorites = sut.fetchAllFavorites()

        // Then
        XCTAssertEqual(favorites.count, 2, "There should be 2 favorites in the list.")
        XCTAssertTrue(favorites.contains { $0.symbol == crypto1.symbol }, "Favorites list should include BTC.")
        XCTAssertTrue(favorites.contains { $0.symbol == crypto2.symbol }, "Favorites list should include ETH.")
    }

    func test_isFavorite_withNonExistentCrypto_shouldReturnFalse() {
        // Given
        let crypto = Cryptocurrency(symbol: "DOGE", price: "0.05", time: 22222, dailyChange: "0.1", ts: 33333)

        // When
        let isFavorite = sut.isFavorite(crypto: crypto)

        // Then
        XCTAssertFalse(isFavorite, "Non-existent crypto should not be marked as favorite.")
    }
    
    func test_toggleFavorite_shouldNotifyObservers() {
        // Given
        let crypto = Cryptocurrency(symbol: "BTC", price: "10000", time: 12345, dailyChange: "0.02", ts: 67890)

        // When
        sut.toggleFavorite(crypto: crypto)

        // Then
        XCTAssertEqual(notifier.notifications.count, 1, "Notifier should post one notification.")
        XCTAssertEqual(notifier.notifications.first?.0, "BTC", "Notifier should post the correct symbol.")
        XCTAssertTrue(notifier.notifications.first?.1 == true, "Notifier should indicate the crypto is now a favorite.")
    }
}


final class MockNotifier: Notifier {
    var notifications: [(String, Bool)] = []

    func postNotification(crypto: (String, Bool)) {
        notifications.append(crypto)
    }
}

extension CoreDataService {
    static func createForTesting(notifier: Notifier) -> CoreDataService {
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType

        return CoreDataService(
            notifier: notifier,
            persistentStoreDescription: description
        )
    }
}
