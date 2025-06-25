//
//  Cryptocurrency.swift
//  CryptoTracking
//
//  Created by Mahmoud Farag on 21/12/2024.
//

import Foundation
struct Cryptocurrency: Decodable, Hashable {
    var symbol: String
    var price: String
    var time: Int64
    var dailyChange: String
    var ts: Int64
    var isFavorite: Bool? = false 

    
    var formattedDailyChange: String {
        Formatter.shared.formattTwoDecimalsPercent(number: Double(dailyChange) ?? 0)
    }
    
    var formattedPrice: String {
        Formatter.shared.formatToNumberOfdigits(of: Double(price) ?? 0, maxNumberOfDigits: 9)
    }
}

