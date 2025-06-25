//
//  ItemView.swift
//  CryptoTracking
//
//  Created by Mahmoud Farag on 22/12/2024.
//

import SwiftUI

struct CryptoCardView: View {
    @Binding var crypto: Cryptocurrency
    let onTap: () -> Void
    
    private let realmManager = CoreDataService.shared

    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(.white.shadow(.drop(color: Color.theme.accent.opacity(0.2), radius: 2)))
            .frame(height: 80)
            .overlay {
                item
            }
    }
    
    private var item: some View {
        HStack() {
            // Cryptocurrency symbol
            VStack(alignment: .leading) {
                Text(crypto.symbol)
                    .font(.body)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                    .lineLimit(1)
                
                Spacer()
                
                // Current price
                Text(crypto.formattedPrice)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
            }

            
            Spacer()
            
            // Daily change
            DailyChangeView(
                dailyChage: Double(crypto.dailyChange) ?? 0,
                dailyChangeFormatted: crypto.formattedDailyChange
            )
            
            // Favorite button
            favoriteButton
        }
        .padding()
        .contentShape(Rectangle())
        .onTapGesture {
            onTap()
        }
    }
    
    private var favoriteButton: some View {
        Button(action: toggleFavorite) {
            Image(systemName: crypto.isFavorite! ? "heart.fill" : "heart")
                .foregroundColor(crypto.isFavorite! ? .red : .gray)
                .scaleEffect(crypto.isFavorite! ? 1.2 : 1.0)
                .animation(.easeInOut, value: crypto.isFavorite!)
        }
        .buttonStyle(BorderlessButtonStyle()) 
    }
    
    private func toggleFavorite() {
        realmManager.toggleFavorite(crypto: crypto)
        crypto.isFavorite!.toggle()
    }
}

#Preview {
    CryptoCardView(crypto: .constant(CR1)) {
        
    }.padding(/*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
    
}

let CR1 = Cryptocurrency(symbol: "BTC_USDD", price: "99000", time: 1735078594260, dailyChange: "0.0465", ts: 1735078594273)

struct DailyChangeView: View {
    let dailyChage: Double
    let dailyChangeFormatted: String
    
    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(dailyChage < 0 ? Color.theme.red : Color.theme.green)
            .frame(width: 72, height: 28)
            .overlay {
                Text(dailyChangeFormatted)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
            }
    }
}
