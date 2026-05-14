//
//  StockListRowViewModel.swift
//  StockMarket
//
//  Created by Yury Ramazanov on 14.05.2026.
//

import StockMonitor

struct StockListItemViewModel {
    let symbol: String
    let name: String
    let price: Double
    let previousPrice: Double
    
    var changePercentage: Double {
        guard previousPrice != 0 else { return 0 }
        return (price - previousPrice) / previousPrice
    }
    
    var isGaining: Bool {
        changePercentage >= 0
    }
    
    init(stock: StockItem) {
        self.symbol = stock.symbol
        self.name = stock.shortName
        self.price = stock.currentPrice
        self.previousPrice = stock.previousPrice
    }
}
