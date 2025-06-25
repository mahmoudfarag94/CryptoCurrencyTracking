//
//  LocalDatabaseService.swift
//  CryptoTracking
//
//  Created by Mahmoud Farag on 22/12/2024.
//

import Foundation
protocol LocalDatabaseService {
    func toggleFavorite(crypto:  Cryptocurrency)
    func isFavorite(crypto: Cryptocurrency) -> Bool
    func fetchAllFavorites() -> [Cryptocurrency]
}

import CoreData

final class CoreDataService: LocalDatabaseService {
    
    static let shared = CoreDataService() // Singleton instance
    private let container: NSPersistentContainer
    private let notifier: Notifier
    private init(notifier: Notifier = CryptoNotifier()) {
        self.notifier = notifier
        container = NSPersistentContainer(name: "CryptoTracking")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data stack initialization failed: \(error)")
            }
        }
    }
    
    /// Internal initializer for testing
    internal init(
        notifier: Notifier = CryptoNotifier(),
        persistentStoreDescription: NSPersistentStoreDescription
    ) {
        self.notifier = notifier
        container = NSPersistentContainer(name: "CryptoTracking")
        container.persistentStoreDescriptions = [persistentStoreDescription]
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data stack initialization failed: \(error)")
            }
        }
    }
    
    private var context: NSManagedObjectContext {
        container.viewContext
    }
    
    // Toggle favorite status
    func toggleFavorite(crypto: Cryptocurrency) {
        var favorite: Bool
        if let existing = fetchFavorite(symbol: crypto.symbol) {
            context.delete(existing)
            favorite = false
        } else {
            let entity = CryptocurrencyEntity(context: context)
            entity.symbol = crypto.symbol
            entity.dailyChange = crypto.dailyChange
            entity.price = crypto.price
            entity.time = crypto.time
            entity.ts = crypto.ts
            favorite  = true
        }
        saveContext()
        notifier.postNotification(crypto: (crypto.symbol, favorite))
    }
    
    // Check if a cryptocurrency is a favorite
    func isFavorite(crypto: Cryptocurrency) -> Bool {
        fetchFavorite(symbol: crypto.symbol) != nil
    }
    
    func fetchAllFavorites() -> [Cryptocurrency] {
        let request: NSFetchRequest<CryptocurrencyEntity> = CryptocurrencyEntity.fetchRequest()
        let entities =  (try? context.fetch(request)) ?? []
        return  entities.map {$0.toEntity()
    }

        
    }
    
    // MARK: - Private Helpers
    
    private func fetchFavorite(symbol: String) -> CryptocurrencyEntity? {
        let request: NSFetchRequest<CryptocurrencyEntity> = CryptocurrencyEntity.fetchRequest()
        request.predicate = NSPredicate(format: "symbol == %@", symbol)
        return (try? context.fetch(request))?.first
    }
    
    
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                fatalError("Failed to save Core Data context: \(error)")
            }
        }
    }
}


extension CryptocurrencyEntity {
    func toEntity() -> Cryptocurrency {
        Cryptocurrency(symbol: self.symbol ?? "", price: self.price ?? "", time: self.time, dailyChange: self.dailyChange ?? "", ts: self.ts, isFavorite: true)
    }
    
}

