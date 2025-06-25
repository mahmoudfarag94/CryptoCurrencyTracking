//
//  APIEndpoint.swift
//  CryptoTracking
//
//  Created by Mahmoud Farag on 21/12/2024.
//

import Foundation


protocol APIEndpointContract{
    var method: HTTPMethod {get}
    var path: String {get}
    
    var queryItems: [URLQueryItem]? {get}
}


extension APIEndpointContract {
    var urlRequest: URLRequest? {
        var components = URLComponents()
        let baseURL = Configuration.baseURL
        components.scheme = baseURL.scheme
        components.host = baseURL.host
        components.path = baseURL.path + path
        components.queryItems = queryItems
        
        guard let url = components.url else {
            return nil
        }
        
        return URLRequest(url: url)
    }
    
    var method: HTTPMethod {
        .GET
    }
}


enum HTTPMethod: String {
    case GET, POST
}


enum APIEndpoint: APIEndpointContract {
    case cryptocurrencies
    case detail(String)
    
    var path: String {
        return switch self {
        case .cryptocurrencies:
            "/price"
            
        case .detail(let id):
            "/\(id)/ticker24h"
        }
    }
    
    var queryItems: [URLQueryItem]? {return []}
    
}

