//
//  JsonModels.swift
//  StockMonitor
//
//  Created by Yury Ramazanov on 14.05.2026.
//

import Foundation
@testable import StockMonitor

func jsonValue<T>(_ value: T?) -> Any {
    return value.map { $0 as Any } ?? NSNull()
}

func makeErrorJSON(message: String) -> Data {
    let json = [
        "message": message
    ]
    return try! JSONSerialization.data(withJSONObject: json)
}

func makeStockItem(
    symbol: String,
    shortName: String,
    region: String,
    time: Int,
    previousPrice: Double,
    currentPrice: Double
) -> (model: StockItem, json: [String: Any]) {
    let model = StockItem(
        symbol: symbol,
        shortName: shortName,
        region: region,
        time: time,
        previousPrice: previousPrice,
        currentPrice: currentPrice
    )
    let json: [String: Any] = [
        "symbol": symbol,
        "shortName": shortName,
        "region": region,
        "regularMarketTime": [
            "raw": time
        ],
        "regularMarketPreviousClose": [
            "raw": previousPrice
        ],
        "regularMarketPrice": [
            "raw": currentPrice
        ]
    ]
    
    return (model, json)
}

func makeStockDetailsItem(
    symbol: String,
    previousClose: Double? = nil,
    open: Double? = nil,
    dayLow: Double? = nil,
    dayHigh: Double? = nil,
    volume: Int64? = nil,
    averageVolume: Int64? = nil,
    fiftyTwoWeekLow: Double? = nil,
    fiftyTwoWeekHigh: Double? = nil,
    fiftyDayAverage: Double? = nil,
    twoHundredDayAverage: Double? = nil,
    currency: String? = nil
) -> (model: StockItemDetails, json: [String: Any]) {
    let model = StockItemDetails(
        symbol: symbol,
        previousClose: previousClose,
        open: open,
        dayLow: dayLow,
        dayHigh: dayHigh,
        volume: volume,
        averageVolume: averageVolume,
        fiftyTwoWeekLow: fiftyTwoWeekLow,
        fiftyTwoWeekHigh: fiftyTwoWeekHigh,
        fiftyDayAverage: fiftyDayAverage,
        twoHundredDayAverage: twoHundredDayAverage,
        currency: currency
    )
    let json: [String: Any] = [
        "symbol": symbol,
        "quoteSummary": [
            "summaryDetail": [
                "previousClose": jsonValue(previousClose),
                "open": jsonValue(open),
                "dayLow": jsonValue(dayLow),
                "dayHigh": jsonValue(dayHigh),
                "volume": jsonValue(volume),
                "averageVolume": jsonValue(averageVolume),
                "fiftyTwoWeekLow": jsonValue(fiftyTwoWeekLow),
                "fiftyTwoWeekHigh": jsonValue(fiftyTwoWeekHigh),
                "fiftyDayAverage": jsonValue(fiftyDayAverage),
                "twoHundredDayAverage": jsonValue(twoHundredDayAverage),
                "currency": jsonValue(currency)
            ]
        ]
    ]
    
    return (model, json)
}

func makeStocksJSON(_ items: [[String: Any]], error: String? = nil) -> Data {
    let json: [String: Any] = [
        "marketSummaryAndSparkResponse": [
            "result": items,
            "error": jsonValue(error)
        ]
    ]
    
    return try! JSONSerialization.data(withJSONObject: json)
}

func makeStockDetailsJSON(_ items: [[String: Any]], error: String? = nil) -> Data {
    let json: [String: Any] = [
        "quoteResponse": [
            "result": items,
            "error": jsonValue(error)
        ]
    ]
    
    return try! JSONSerialization.data(withJSONObject: json)
}
