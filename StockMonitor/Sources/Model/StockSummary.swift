//
//  StockSummary.swift
//  StockMonitor
//
//  Created by Yury Ramazanov on 13.05.2026.
//

struct StockSummaryResponse: Decodable {
    let marketSummaryAndSparkResponse: MarketSummaryAndSparkResponse
}

struct MarketSummaryAndSparkResponse: Decodable {
    let result: [MarketSummaryItem]
    let error: String?
}

struct MarketSummaryItem: Decodable {
    let symbol: String?
    let shortName: String?
    let regularMarketTime: MarketValue<Int>?
    let regularMarketPreviousClose: MarketValue<Double>?
    let regularMarketPrice: MarketValue<Double>?
}

struct MarketValue<T: Decodable>: Decodable {
    let raw: T?
    let fmt: String?
}
