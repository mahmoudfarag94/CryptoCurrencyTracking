//
//  FavoriteCryptocurrenciesView.swift
//  CryptoTracking
//
//  Created by Mahmoud Farag on 21/12/2024.
//

import SwiftUI

struct FavoriteCryptocurrenciesView: View {
    @ObservedObject var viewModel: FavoritesViewModel
    @StateObject var coordinator: AppCoordinator = AppCoordinator()
    
    var body: some View {
        NavigationStack(path: $coordinator.navigationPath) {
            CryptoListView(
                state: viewModel.state,
                lastUpdate: nil,
                retry: nil,
                listContent: { cryptos in
                    List(cryptos, id: \.symbol) { crypto in
                        CryptoCardView(crypto: .constant(crypto)) {
                            coordinator.showDetails(for: crypto)
                        }
                    }
                    .listStyle(.plain)
                    .navigationTitle("Favorites")
                }
            )
            .navigationDestination(for: Cryptocurrency.self) { value in
                CryptoDetailsView(viewModel: .init(cryptoID: value.symbol))
            }
        }
        .onAppear(perform: viewModel.fetchData)
    }
}

#Preview {
    FavoriteCryptocurrenciesView(viewModel: .init())
}
