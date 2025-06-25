//
//  Mocks.swift
//  CryptoTrackingTests
//
//  Created by Mahmoud Farag on 27/12/2024.
//

import XCTest
@testable import CryptoTracking

// MARK: - MOCKS

class MockURLSession: URLSessionProtocol {
    var mockData: Data?
    var mockResponse: URLResponse?
    var mockError: Error?
    
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        if let error = mockError {
            throw error
        }
        guard let data = mockData, let response = mockResponse else {
            throw AppError.unknown(message: "Mock response not set.")
        }
        return (data, response)
    }
}


struct TestModel: Codable, Equatable {
    let id: Int
    let name: String
}

struct MockAPIEndpoint: APIEndpointContract {
    var path: String = ""
    
    var queryItems: [URLQueryItem]?
    
    var urlRequest: URLRequest? {
        return URLRequest(url: URL(string: "https://example.com")!)
    }
}


class NetworkServiceMock: NetworkService {
    var mockResult: Result<Decodable, AppError>?
    
    func fetch<T>(endpoint: any CryptoTracking.APIEndpointContract) async throws -> T? where T : Decodable {
        switch mockResult {
        case .success(let data as T):
            return data
        default:
            return nil
        }
    }
}

// NetworkMonitor Mock
class NetworkMonitorMock: NetworkMonitorContract {
    var isConnected: Bool = true
}



class ErrorManagerMock: ErrorManagerContract {
    var currentError: String?
    
    var didCallShowError = false
    func showError(_ message: String) {
        didCallShowError = true
        currentError = message
    }
    
    func clearError() {
        currentError = nil
        didCallShowError = false
    }
}





extension Notification.Name {
    static let CryptoChange = Notification.Name("CryptoChange")
}

let sampleCryptos: [Cryptocurrency] = [
    Cryptocurrency(symbol: "BTC", price: "10000", time: 12345, dailyChange: "0.05", ts: 67890, isFavorite: false),
    Cryptocurrency(symbol: "ETH", price: "5000", time: 54321, dailyChange: "0.02", ts: 98765, isFavorite: false),
]


let favoriteCryptos: [Cryptocurrency] = [
    Cryptocurrency(symbol: "BTC", price: "10000", time: 12345, dailyChange: "0.05", ts: 67890, isFavorite: true),
    Cryptocurrency(symbol: "ETH", price: "5000", time: 54321, dailyChange: "0.02", ts: 98765, isFavorite: false),
]


let filteredCryptos = sampleCryptos.filter { $0.symbol.contains("BTC") }

let tickSample = TickerModel(
    symbol: "BTC_USDD",
    open: "94251",
    low: "94251",
    high: "99500",
    close: "99299",
    quantity: "0.002493",
    amount: "245.28447133",
    tradeCount: 36,
    startTime: 1735035600000,
    closeTime: 1735122048214,
    displayName: "97002.69",
    dailyChange: "0.000598",
    bid: "99465.59",
    bidQuantity: "0.03",
    ask: "99465.59",
    askQuantity: "0.03",
    ts: 1735122048838,
    markPrice: "99299"
    
)
