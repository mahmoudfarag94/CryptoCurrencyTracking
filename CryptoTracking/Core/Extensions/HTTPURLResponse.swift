//
//  HTTPURLResponse.swift
//  Cryptify
//
//  Created by Jan Babák on 12.12.2022.
//

import Foundation

extension HTTPURLResponse {
    func checkErrors() throws {
        if isServerError() {
            let error = AppError.server(statusCode: self.statusCode)
            ErrorManager.shared.showError(error.errorDescription)
            throw error
        }
        
        if isClientError() {
            if statusCode == 429 {
                throw AppError.rateLimitExceeded
            } else {
                throw AppError.client(statusCode: self.statusCode)
            }
        }
        
        if !isOK() {
            throw AppError.unknown(message: "HTTP Error: \(self.statusCode)")
        }
    }
    
    func isOK() -> Bool {
        (200...299).contains(statusCode)
    }
    
    func isServerError() -> Bool {
        (500...599).contains(statusCode)
    }
    
    func isClientError() -> Bool {
        (400...499).contains(statusCode)
    }
}
