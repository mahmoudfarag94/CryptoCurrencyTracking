//
//  CryptoTrackingApp.swift
//  CryptoTracking
//
//  Created by Mahmoud Farag on 21/12/2024.
//

import SwiftUI
import netfox

@main
struct CryptocurrencyTrackingApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        _ = NetworkMonitor.shared
    }
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .globalErrorToast()
        }
    }
}
