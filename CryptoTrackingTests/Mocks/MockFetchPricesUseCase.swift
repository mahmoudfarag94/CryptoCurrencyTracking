//
//  MockFetchPricesUseCase.swift
//  CryptoTrackingTests
//
//  Created by Mahmoud Farag on 27/12/2024.
//

import Foundation
import XCTest
import Combine
@testable import CryptoTracking
typealias MockResult = Result<[Cryptocurrency], AppError>

final class MockFetchPricesUseCase: FetchPricesUseCase {
    var result: Result<[Cryptocurrency], AppError>!
    
    func execute() async throws -> [Cryptocurrency] {
        switch result {
        case .success(let data):
            return data
        case .failure(let error):
            throw error
        case .none:
            fatalError("No result set in MockFetchPricesUseCase")
        }
    }
}

