//
//  CryptoListView.swift
//  CryptoTracking
//
//  Created by Mahmoud Farag on 25/12/2024.
//

import Foundation
import SwiftUI

struct CryptoListView<Content: View>: View {
    let state: ViewState<[Cryptocurrency]>
    let lastUpdate: Date?
    let retry: (() async -> Void)?
    let listContent: ([Cryptocurrency]) -> Content
    
    
    var body: some View {
        switch state {
        case .idle:
            Text("Start searching for cryptocurrencies.")
                .foregroundColor(.gray)
        case .loading:
            LoadingView()
        case .success(let cryptos):
            VStack {
                if let lastUpdate = lastUpdate {
                    HStack {
                        Text("Last Update:")
                        Text(lastUpdate, style: .relative)
                        Text(" ago")
                    }
                    .font(.headline)
                    .foregroundColor(Color.theme.green)
                    .padding()
                }
                listContent(cryptos)
            }
            
        case .error(let errorMessage):
            ErrorView(heading: errorMessage,tryAgainAction: retry)
        }
    }
}
