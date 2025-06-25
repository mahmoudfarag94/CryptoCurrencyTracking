//
//  NetworkMonitor.swift
//  CryptoTracking
//
//  Created by Mahmoud Farag on 24/12/2024.
//

import Foundation
import Network

final class NetworkMonitor: NetworkMonitorContract {
    static let shared = NetworkMonitor()
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    
    var isConnected: Bool = true
    
    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                if path.status == .satisfied {
                    self?.isConnected = true
                } else {
                    self?.isConnected = false
                    ErrorManager.shared.showError("You are offline. Please check your connection.")
                }
            }
        }
        monitor.start(queue: queue)
    }
}


protocol NetworkMonitorContract {
    var isConnected: Bool {get}
}




import SwiftUI
import Combine

protocol ErrorManagerContract {
    var currentError: String? {get}
    func showError(_ message: String)
    func clearError()
    
}

final class ErrorManager: ObservableObject,ErrorManagerContract {
    static let shared = ErrorManager()
    
    @Published var currentError: String? = nil

    private init() {}

    func showError(_ message: String) {
        DispatchQueue.main.async {
            self.currentError = message
        }
    }

    func clearError() {
        currentError = nil
    }
}


struct ToastView: View {
    let message: String

    var body: some View {
        HStack {
            Text(message)
                .font(.headline)
                .foregroundColor(.white)
            Spacer()
        }
        .padding()
        .background(Color.red.opacity(0.9))
        .cornerRadius(12)
        .shadow(radius: 4)
        .padding(.horizontal)
        .transition(.move(edge: .top).combined(with: .opacity))
    }
}


struct GlobalErrorToastModifier: ViewModifier {
    @ObservedObject var errorManager = ErrorManager.shared

    func body(content: Content) -> some View {
        ZStack {
            content

            if let errorMessage = errorManager.currentError {
                VStack {
                    ToastView(message: errorMessage)
                        .onTapGesture {
                            withAnimation {
                                errorManager.clearError()
                            }
                        }
                    Spacer()
                }
                .zIndex(1) // Ensure it appears above other content
            }
        }
        .animation(.easeInOut, value: errorManager.currentError)
    }
}

// Convenience view extension for adding the modifier
extension View {
    func globalErrorToast() -> some View {
        self.modifier(GlobalErrorToastModifier())
    }
}
