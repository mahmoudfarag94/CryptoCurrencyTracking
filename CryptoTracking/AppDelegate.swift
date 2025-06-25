//
//  AppDelegate.swift
//  CryptoTracking
//
//  Created by Mahmoud farag on 25/06/2025.
//

import UIKit
import netfox

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
//        #if DEBUG
        NFX.sharedInstance().start()
//        #endif
        return true
    }
}
