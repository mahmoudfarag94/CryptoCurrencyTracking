//
//  CryptoDetailsView.swift
//  CryptoTracking
//
//  Created by Mahmoud Farag on 22/12/2024.
//

import SwiftUI
struct CryptoDetailsView: View {
    @StateObject var viewModel: CryptoDetailsViewModel
    var body: some View {
        content
    }
    
    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle:
            Text("Start searching for cryptocurrencies.")
                .foregroundColor(.gray)
            
        case .loading:
            LoadingView()
            
        case .success(let crypto):
            DetailView(crypto: crypto)
            
        case .error(let errorMessage):
            ErrorView(heading: errorMessage) {
                viewModel.fetchData()
            }
        }
    }
}

#Preview {
    NavigationView {
        CryptoDetailsView(viewModel: .init(cryptoID: "BTC_USDC"))
    }
    
}
