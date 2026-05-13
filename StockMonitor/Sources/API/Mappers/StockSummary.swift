//
//  StockSummary.swift
//  StockMonitor
//
//  Created by Yury Ramazanov on 13.05.2026.
//

struct StockSummaryResponse: Decodable {
    let marketSummaryAndSparkResponse: MarketSummaryAndSparkResponse
    
    var items: [StockItem] {
        return marketSummaryAndSparkResponse
            .result
            .map { item in
                StockItem(symbol: item.symbol,
                          shortName: item.shortName,
                          time: item.regularMarketTime.raw,
                          previousPrice: item.regularMarketPreviousClose.raw,
                          currentPrice: item.regularMarketPrice.raw)
            }
    }
}

struct MarketSummaryAndSparkResponse: Decodable {
    let result: [MarketSummaryItem]
    let error: String?
}

struct MarketSummaryItem: Decodable {
    let symbol: String
    let shortName: String
    let regularMarketTime: MarketValue<Int>
    let regularMarketPreviousClose: MarketValue<Double>
    let regularMarketPrice: MarketValue<Double>
}

struct MarketValue<T: Decodable>: Decodable {
    let raw: T
    let fmt: String?
}
