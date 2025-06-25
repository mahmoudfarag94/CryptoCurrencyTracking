//
//  CryptoRepositoryImpl.swift
//  CryptoTracking
//
//  Created by Mahmoud Farag on 21/12/2024.
//

import Foundation
import Combine
final class CryptoRepositoryImpl: CryptoRepository {
    var networkMonitor: any NetworkMonitorContract
    internal let networkService: NetworkService
    private let errorManager: ErrorManagerContract
    private let databaseService: LocalDatabaseService
    
    init(
        networkService: NetworkService = NetworkManager(),
        networkMonitor: NetworkMonitorContract = NetworkMonitor.shared,
        errorManager: ErrorManagerContract = ErrorManager.shared,
        databaseService: LocalDatabaseService = CoreDataService.shared
    ) {
        self.networkService = networkService
        self.networkMonitor = networkMonitor
        self.errorManager = errorManager
        self.databaseService = databaseService
    }
    
    func fetchPrices() async -> Result<[Cryptocurrency], AppError> {
        let result: Result<[Cryptocurrency], AppError> = await fetch(endpoint: APIEndpoint.cryptocurrencies)
        
        switch result {
        case .success(let cryptocurrencies):
            // Merge local favorites into the fetched list
            let updatedCryptocurrencies = mergeWithLocalFavorites(cryptocurrencies: cryptocurrencies)
            return .success(updatedCryptocurrencies)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    private func mergeWithLocalFavorites(cryptocurrencies: [Cryptocurrency]) -> [Cryptocurrency] {
        let favoriteSymbols = databaseService.fetchAllFavorites().map { $0.symbol }
                
        return cryptocurrencies.map { crypto in
            var updatedCrypto = crypto
            updatedCrypto.isFavorite = favoriteSymbols.contains(crypto.symbol)
            return updatedCrypto
        }
    }
}
