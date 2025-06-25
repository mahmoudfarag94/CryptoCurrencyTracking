//
//  MockFetchDetailUseCase.swift
//  CryptoTrackingTests
//
//  Created by Mahmoud Farag on 27/12/2024.
//

import Foundation
import Combine
@testable import CryptoTracking

class MockFetchDetailUseCase: FetchDetailUseCase {
    var result: Result<TickerModel, AppError>!
    
    func execute(id: String) async throws -> TickerModel {
        switch result {
        case .success(let detail):
            return detail
        case .failure(let error):
            throw error
        case .none:
            fatalError("Result not set")
        }
    }
}
