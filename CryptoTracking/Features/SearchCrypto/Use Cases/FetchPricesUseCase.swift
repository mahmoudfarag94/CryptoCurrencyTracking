//
//  FetchCryptocurrenciesUseCase.swift
//  CryptoTracking
//
//  Created by Mahmoud Farag on 21/12/2024.
//

import Foundation
import Combine

protocol FetchPricesUseCase {
    func execute() async throws -> [Cryptocurrency]
}

final class FetchPricesUseCaseImpl: FetchPricesUseCase {
    private let repository: CryptoRepositoryContract
    
    init(repository: CryptoRepositoryContract = CryptoRepositoryImpl()) {
        self.repository = repository
    }
    
    func execute() async throws -> [Cryptocurrency] {
        let result =  await repository.fetchPrices()
        switch result {
        case .success(let cryptos):
            return cryptos.sorted(by: { $0.price > $1.price })
        case .failure(let err):
            throw err
        }
    }
}

