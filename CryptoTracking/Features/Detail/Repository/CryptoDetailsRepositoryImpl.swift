//
//  CryptoDetailsRepositoryImpl.swift
//  CryptoTracking
//
//  Created by Mahmoud Farag on 27/12/2024.
//

import Foundation

final class CryptoDetailsRepositoryImpl: DetailRepository {
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
        
    
    func fetchCryptoDetails(id: String) async -> Result<TickerModel, AppError> {
        await fetch(endpoint: APIEndpoint.detail(id))
    }
}
