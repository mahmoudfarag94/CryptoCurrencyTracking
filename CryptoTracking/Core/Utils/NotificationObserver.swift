//
//  NotificationObserver.swift
//  CryptoTracking
//
//  Created by Mahmoud Farag on 27/12/2024.
//

import Foundation


extension Notification.Name {
    static let CryptoChange = Notification.Name("CryptoChange")
}

protocol Notifier {
    func postNotification(crypto: (String,Bool))
}

struct CryptoNotifier: Notifier{
    func postNotification(crypto: (String,Bool)) {
        NotificationCenter.default.post(
            name: .CryptoChange,
            object: nil,
            userInfo: ["symbol": crypto.0, "isFavorite": crypto.1]
        )
    }
}
