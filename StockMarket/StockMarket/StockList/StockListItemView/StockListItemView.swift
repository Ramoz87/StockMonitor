//
//  StockListItemView.swift
//  StockMarket
//
//  Created by Yury Ramazanov on 14.05.2026.
//

import SwiftUI
import StockMonitor

struct StockListItemView: View {
    private let model: StockListItemViewModel
    
    init(stock: StockItem) {
        self.model = StockListItemViewModel(stock: stock)
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(model.name)
                    .bold()
                    .lineLimit(1)
                
                Text(model.symbol)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text(model.price, format: .currency(code: "USD").precision(.fractionLength(2)))
                    .bold()
                
                Label {
                    Text(model.changePercentage, format: .percent.precision(.fractionLength(2)))
                } icon: {
                    Image(systemName: model.isGaining ? "arrow.up.right" : "arrow.down.right")
                }
                .foregroundStyle(model.isGaining ? .green : .red)
                .labelStyle(.titleAndIcon)
            }
        }
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    List {
        StockListItemView(stock: .init(symbol: "AAPL",
                                       shortName: "Apple Inc.",
                                       time: 0,
                                       previousPrice: 205.50,
                                       currentPrice: 210.30))
    }
}
