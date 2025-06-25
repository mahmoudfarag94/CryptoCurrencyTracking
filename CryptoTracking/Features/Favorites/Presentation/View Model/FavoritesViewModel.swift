//
//  FavoritesViewModel.swift
//  CryptoTracking
//
//  Created by Mahmoud Farag on 21/12/2024.
//

import Combine
import Foundation

final class FavoritesViewModel: BaseCryptoViewModel {


    override init(fetchUseCase: FetchPricesUseCase = FetchPricesUseCaseImpl(repository: FavoritesRepository())) {
        super.init(fetchUseCase: fetchUseCase)
    } 
 
    override func onChange(symbol: String, isFavorite: Bool) {
        fetchData()
    }
}


