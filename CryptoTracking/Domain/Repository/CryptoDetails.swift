//
//  CryptoDetails.swift
//  CryptoTracking
//
//  Created by Mahmoud Farag on 27/12/2024.
//

import Foundation

typealias DetailRepository = Repository & CryptoDetails

protocol CryptoDetails {
    func fetchCryptoDetails(id: String) async -> Result<TickerModel, AppError>
}
