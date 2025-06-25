//
//  DetailView.swift
//  CryptoTracking
//
//  Created by Mahmoud Farag on 26/12/2024.
//

import SwiftUI

struct DetailView: View {
    let crypto: TickerModel
    
    var body: some View {
        VStack(spacing: 16) {
            // Header with symbol and close price
            headerView
            
            Divider()
            
            // Price Range Section
            HStack {
                priceRangeView
            }
            
            Divider()
            
            // Trade Details Section
            tradeDetailsView
            
            Divider()
            
            // Bid/Ask Section
            bidAskView
        }
        .padding()
        .navigationTitle(crypto.displayName)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var headerView: some View {
        VStack(spacing: 8) {
            Text(crypto.symbol)
                .font(.headline)
                .foregroundColor(.gray)
            
            Text("$\(Double(crypto.close) ?? 0.0, specifier: "%.2f")")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text(dailyChangeText)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(dailyChangeColor)
        }
    }
    
    private var priceRangeView: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Price Range")
                .font(.headline)
                .padding(.bottom, 4)
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Low: \(crypto.low)")
                    Text("High: \(crypto.high)")
                }
                Spacer()
            }
        }
    }
    
    private var tradeDetailsView: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Trade Details")
                .font(.headline)
                .padding(.bottom, 4)
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Quantity: \(crypto.quantity)")
                    Text("Amount: \(crypto.amount)")
                    Text("Trade Count: \(crypto.tradeCount)")
                }
                Spacer()
            }
        }
    }
    
    private var bidAskView: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Bid/Ask")
                .font(.headline)
                .padding(.bottom, 4)
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Bid: \(crypto.bid) (\(crypto.bidQuantity))")
                    Text("Ask: \(crypto.ask) (\(crypto.askQuantity))")
                }
                Spacer()
            }
        }
    }
    
    private var dailyChangeText: String {
        let change = Double(crypto.dailyChange) ?? 0
        let percentage = change * 100
        return "\(percentage >= 0 ? "+" : "")\(String(format: "%.2f", percentage))%"
    }
    
    private var dailyChangeColor: Color {
        let change = Double(crypto.dailyChange) ?? 0
        return change >= 0 ? .green : .red
    }
}

#Preview {
    DetailView(crypto: sampleCrypto)
}

let sampleCrypto = TickerModel(
    symbol: "BTC_USDD",
    open: "94251",
    low: "94251",
    high: "99500",
    close: "99299",
    quantity: "0.002493",
    amount: "245.28447133",
    tradeCount: 36,
    startTime: 1735035600000,
    closeTime: 1735122048214,
    displayName: "97002.69",
    dailyChange: "0.000598",
    bid: "99465.59",
    bidQuantity: "0.03",
    ask: "99465.59",
    askQuantity: "0.03",
    ts: 1735122048838,
    markPrice: "99299"
    
)
