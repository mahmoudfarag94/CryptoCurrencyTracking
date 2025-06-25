//
//  MainTabView.swift
//  CryptoTracking
//
//  Created by Mahmoud Farag on 21/12/2024.
//

import SwiftUI

struct MainTabView: View {    
    @StateObject var coordinator: AppCoordinator = AppCoordinator()
    var body: some View {
        TabView {
            SearchCryptocurrenciesView(viewModel:.init())
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
            
            RealTimePricesView(viewModel:.init())
                .tabItem {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                    Text("Prices")
                }
            
            FavoriteCryptocurrenciesView(viewModel: .init())
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("Favorites")
                }
        }
    }
}

#Preview {
    MainTabView()
}
