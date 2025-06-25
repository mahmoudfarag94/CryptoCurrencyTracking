//
//  CryptoTrackingApp.swift
//  CryptoTracking
//
//  Created by Mahmoud farag on 25/06/2025.
//

import SwiftUI

@main
struct CryptoTrackingApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
