//
//  NetworkManager.swift
// CryptoTracking
//
//  Created by Mahmoud Farag on 21/12/2024.
//

import Foundation

final class NetworkManager: NetworkService {
    private let session: URLSessionProtocol
    private let decoder: JSONDecoder
    
    init(session: URLSessionProtocol = URLSession.shared, decoder: JSONDecoder = .init()) {
        self.session = session
        self.decoder = decoder
        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    func fetch<T: Decodable>(endpoint: APIEndpointContract) async throws -> T {
        guard let urlRequest = endpoint.urlRequest else {
            throw AppError.badURL
        }
        
        do {
            // Perform network call with injected session
            let (data, response) = try await session.data(for: urlRequest)
            
            // Verify the HTTP response and handle errors
            guard let httpResponse = response as? HTTPURLResponse else {
                throw AppError.unknown(message: "No HTTP URL response found.")
            }
            try httpResponse.checkErrors()
            
            // Decode the data into the specified type
            return try decode(data)
            
        } catch let error as AppError {
            throw error
        } catch {
            throw AppError.unknown(message: error.localizedDescription)
        }
    }
}


extension NetworkManager {
    // Decode a response in a type-safe manner
    private func decode<T: Decodable>(_ data: Data) throws -> T {
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw AppError.decodingFailed
        }
    }
}
