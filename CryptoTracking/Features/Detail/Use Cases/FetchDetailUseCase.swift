//
//  FetchDetailUseCase.swift
//  CryptoTracking
//
//  Created by Mahmoud Farag on 24/12/2024.
//

import Foundation

protocol FetchDetailUseCase {
    func execute(id: String) async throws -> TickerModel
}

final class FetchDetailUseCaseImpl: FetchDetailUseCase {
    private let repository: DetailRepository
    
    init(repository: DetailRepository = CryptoDetailsRepositoryImpl()) {
        self.repository = repository
    }
    
    func execute(id: String) async throws -> TickerModel {
        let result =  await repository.fetchCryptoDetails(id: id)
        switch result {
        case .success(let crypto):
            return crypto
        case .failure(let err):
            throw err
        }
    }
}
