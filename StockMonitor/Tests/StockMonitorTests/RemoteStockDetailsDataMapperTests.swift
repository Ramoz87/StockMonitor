//
//  RemoteStockDetailsDataMapperTests.swift
//  StockMonitor
//
//  Created by Yury Ramazanov on 13.05.2026.
//

import XCTest
@testable import StockMonitor

final class RemoteStockDetailsDataMapperTests: XCTestCase {

    func test_map_throwsErrorOnNon200HTTPCode() throws {
        let json = makeJSON([])
        let codes = [199, 300, 400, 500]
    
        try codes.forEach { code in
            XCTAssertThrowsError (
                try RemoteStockDetailsDataMapper.map(json, HTTPURLResponse(url: anyURL(), statusCode: code, httpVersion: nil, headerFields: nil)!)
            )
        }
    }
    
    func test_map_throwsErrorOn200HTTPCodeAndInvalidJSON() {
        let json = Data("invalid json".utf8)
        XCTAssertThrowsError (
            try RemoteStockDetailsDataMapper.map(json, HTTPURLResponse(statusCode: 200))
        )
    }
    
    func test_map_getEmptyResultOn200HTTPCodeAndEmptyJSON() throws {
        let json = makeJSON([])
        let result = try RemoteStockDetailsDataMapper.map(json, HTTPURLResponse(statusCode: 200))
        XCTAssertEqual(result, nil)
    }
    
    func test_map_getResultOn200HTTPCodeAndNotEmptyJSON() throws {
        let item = makeItem(
            symbol: "AAPL",
            previousClose: 448.29,
            open: 457.595,
            dayLow: 432.65,
            dayHigh: 459.5,
            marketCap: 718263222272,
            volume: 9690920,
            averageVolume: 39315288,
            fiftyTwoWeekLow: 107.67,
            fiftyTwoWeekHigh: 469.22,
            fiftyDayAverage: 264.676,
            twoHundredDayAverage: 220.2454,
            beta: 2.399,
            trailingPE: 146.83,
            forwardPE: 34.126564,
            dividendRate: 0,
            dividendYield: 0,
            currency: "USD"
        )
        let json = makeJSON([item.json])
        
        let result = try RemoteStockDetailsDataMapper.map(json, HTTPURLResponse(statusCode: 200))
        
        XCTAssertEqual(result, item.model)
    }
    
    func test_map_throwErrorOn200HTTPCodeAndNotEmptyError() throws {
        let message = "an error"
        let json = makeJSON([], error: message)
        
        XCTAssertThrowsError(
            try RemoteStockDetailsDataMapper.map(json, HTTPURLResponse(statusCode: 200))
        ) { error in
            guard case let RemoteStockDetailsDataMapper.Error.apiError(receivedMessage) = error else {
                return XCTFail("Expected apiError(\(message)), got \(error) instead")
            }
            
            XCTAssertEqual(receivedMessage, message)
        }
    }
    
    //MARK: - Helpers
    
    private func makeItem(symbol: String,
                          previousClose: Double? = nil,
                          open: Double? = nil,
                          dayLow: Double? = nil,
                          dayHigh: Double? = nil,
                          marketCap: Int64? = nil,
                          volume: Int64? = nil,
                          averageVolume: Int64? = nil,
                          fiftyTwoWeekLow: Double? = nil,
                          fiftyTwoWeekHigh: Double? = nil,
                          fiftyDayAverage: Double? = nil,
                          twoHundredDayAverage: Double? = nil,
                          beta: Double? = nil,
                          trailingPE: Double? = nil,
                          forwardPE: Double? = nil,
                          dividendRate: Double? = nil,
                          dividendYield: Double? = nil,
                          currency: String? = nil) -> (model: StockItemDetails, json: [String: Any]) {
                
                let model = StockItemDetails(
                    symbol: symbol,
                    previousClose: previousClose,
                    open: open,
                    dayLow: dayLow,
                    dayHigh: dayHigh,
                    marketCap: marketCap,
                    volume: volume,
                    averageVolume: averageVolume,
                    fiftyTwoWeekLow: fiftyTwoWeekLow,
                    fiftyTwoWeekHigh: fiftyTwoWeekHigh,
                    fiftyDayAverage: fiftyDayAverage,
                    twoHundredDayAverage: twoHundredDayAverage,
                    beta: beta,
                    trailingPE: trailingPE,
                    forwardPE: forwardPE,
                    dividendRate: dividendRate,
                    dividendYield: dividendYield,
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
                            "marketCap": jsonValue(marketCap),
                            "volume": jsonValue(volume),
                            "averageVolume": jsonValue(averageVolume),
                            "fiftyTwoWeekLow": jsonValue(fiftyTwoWeekLow),
                            "fiftyTwoWeekHigh": jsonValue(fiftyTwoWeekHigh),
                            "fiftyDayAverage": jsonValue(fiftyDayAverage),
                            "twoHundredDayAverage": jsonValue(twoHundredDayAverage),
                            "beta": jsonValue(beta),
                            "trailingPE": jsonValue(trailingPE),
                            "forwardPE": jsonValue(forwardPE),
                            "dividendRate": jsonValue(dividendRate),
                            "dividendYield": jsonValue(dividendYield),
                            "currency": jsonValue(currency)
                        ]
                    ]
                ]
                
                return (model, json)
            }
    
    private func makeJSON(_ items: [[String: Any]], error: String? = nil) -> Data {
        let json: [String: Any] = [
            "quoteResponse": [
                "result": items,
                "error": error.map { $0 as Any } ?? NSNull()
            ]
        ]
        return try! JSONSerialization.data(withJSONObject: json)
    }
}
