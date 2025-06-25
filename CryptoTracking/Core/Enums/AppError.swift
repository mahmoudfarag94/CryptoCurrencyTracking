//
//  AppError.swift
//  CryptoTracking
//
//  Created by Mahmoud Farag on 25/12/2024.
//

import Foundation

enum AppError: Error {
    case rateLimitExceeded
    case unknown(message: String)
    case badURL
    case offline
    case decodingFailed
    case server(statusCode: Int)
    case client(statusCode: Int)
    case empty
    
    var errorDescription: String {
        switch self {
        case .rateLimitExceeded:
            return "Rate limit exceeded. Please try again later."
        case .unknown(let message):
            return "Unknown Error: \(message)"
        case .badURL:
            return "Invalid URL."
        case .decodingFailed:
            return "Decoding of the response data failed."
        case .server(_):
            return "Something went wrong, please try later."
        case .client(let statusCode):
            return "Client Error with status code \(statusCode)."
        case .offline:
            return "The Internet connection appears to be offline."
        case .empty:
            return "No Data Available"
        }
    }
}

extension AppError: Equatable {
    static func == (lhs: AppError, rhs: AppError) -> Bool {
        switch (lhs, rhs) {
        case (.rateLimitExceeded, .rateLimitExceeded):
            return true
        case (.unknown(let lhsMessage), .unknown(let rhsMessage)):
            return lhsMessage == rhsMessage
        case (.badURL, .badURL):
            return true
        case (.offline, .offline):
            return true
        case (.decodingFailed, .decodingFailed):
            return true
        case (.server(let lhsStatusCode), .server(let rhsStatusCode)):
            return lhsStatusCode == rhsStatusCode
        case (.client(let lhsStatusCode), .client(let rhsStatusCode)):
            return lhsStatusCode == rhsStatusCode
        case (.empty, .empty):
            return true
        default:
            return false
        }
    }
}
