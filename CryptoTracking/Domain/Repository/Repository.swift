//
//  Repository.swift
//  CryptoTracking
//
//  Created by Mahmoud Farag on 27/12/2024.
//

import Foundation

protocol Repository {
    var networkMonitor: NetworkMonitorContract {get}
    var networkService: NetworkService {get}
    func checkInternetConnection() -> Bool
    
}

extension Repository {
    func checkInternetConnection() -> Bool {
        if !networkMonitor.isConnected {
            let offlineError = AppError.offline
            ErrorManager.shared.showError(offlineError.errorDescription)
            return false
        }
        return true
    }
}

extension Repository {
    func fetch<T: Decodable>(endpoint: APIEndpoint) async -> Result<T, AppError> {
        guard checkInternetConnection() else {
            return .failure(.offline)
        }
        
        do {
            guard let result: T = try await networkService.fetch(endpoint: endpoint) else {
                return .failure(.decodingFailed)
            }
            return .success(result)
        } catch let error as AppError {
            logError(endpoint: endpoint, error: error)
            return .failure(error)
        } catch {
            let unknownError = AppError.unknown(message: error.localizedDescription)
            logError(endpoint: endpoint, error: unknownError)
            return .failure(unknownError)
        }
    }
    
    private func logError(endpoint: APIEndpoint, error: AppError) {
        print("Handled Network Error for \(endpoint.path): \(error.errorDescription)")
    }
}
