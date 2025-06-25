//
//  RealTimePricesView.swift
//  CryptoTracking
//
//  Created by Mahmoud Farag on 21/12/2024.
//

import SwiftUI

struct RealTimePricesView: View {
    @ObservedObject var viewModel: RealTimePricesViewModel
    @StateObject var coordinator: AppCoordinator = AppCoordinator()
    
    var body: some View {
        NavigationStack(path: $coordinator.navigationPath) {
            CryptoListView(
                state: viewModel.state,
                lastUpdate: viewModel.lastUpdate,
                retry: viewModel.fetchData,
                listContent: { cryptos in
                    List(cryptos, id: \.symbol) { crypto in
                        CryptoCardView(crypto: .constant(crypto)) {
                            coordinator.showDetails(for: crypto)
                        }
                    }
                    .listStyle(.plain)
                    .navigationTitle("Prices")
                }
            ).navigationDestination(for: Cryptocurrency.self) { value in
                CryptoDetailsView(viewModel: .init(cryptoID: value.symbol))
            }
        }
    }
}

#Preview {
    RealTimePricesView(viewModel: .init())
        .environmentObject(AppCoordinator())
}
