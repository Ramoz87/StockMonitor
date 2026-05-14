//
//  Stock.swift
//  StockMonitor
//
//  Created by Yury Ramazanov on 13.05.2026.
//

public struct StockItem: Equatable, Identifiable {
    public var id: String { symbol }
    
    public let symbol: String
    public let shortName: String
    public let time: Int
    public let previousPrice: Double
    public let currentPrice: Double
    
    public init(symbol: String,
                shortName: String,
                time: Int,
                previousPrice: Double,
                currentPrice: Double) {
        self.symbol = symbol
        self.shortName = shortName
        self.time = time
        self.previousPrice = previousPrice
        self.currentPrice = currentPrice
    }
}
