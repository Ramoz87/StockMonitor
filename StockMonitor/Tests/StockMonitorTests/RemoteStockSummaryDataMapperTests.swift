//
//  RemoteStockSummaryDataMapperTests.swift
//  StockMonitor
//
//  Created by Yury Ramazanov on 13.05.2026.
//

import XCTest
@testable import StockMonitor

final class RemoteStockSummaryDataMapperTests: XCTestCase {
    
    func test_map_throwsErrorOnNon200HTTPCode() throws {
        let message = "a response error"
        let json = makeErrorJSON(message: message)
        let codes = [199, 300, 400, 500]
        
        try codes.forEach { code in
            XCTAssertThrowsError(
                try RemoteStockSummaryDataMapper.map(json, HTTPURLResponse(statusCode: code))
            ) { error in
                guard let responseError = error as? ResponseError else {
                    return XCTFail("Expected ResponseError, got \(error) instead")
                }
                
                XCTAssertEqual(responseError.message, message)
            }
        }
    }
    
    func test_map_throwsErrorOn200HTTPCodeAndInvalidJSON() {
        let json = Data("invalid json".utf8)
        
        XCTAssertThrowsError(
            try RemoteStockSummaryDataMapper.map(json, HTTPURLResponse(statusCode: 200))
        )
    }
    
    func test_map_throwErrorOn200HTTPCodeAndNotEmptyError() throws {
        let message = "an error"
        let json = makeJSON([], error: message)
        
        XCTAssertThrowsError(
            try RemoteStockSummaryDataMapper.map(json, HTTPURLResponse(statusCode: 200))
        ) { error in
            guard case let RemoteStockSummaryDataMapper.Error.apiError(receivedMessage) = error else {
                return XCTFail("Expected apiError(\(message)), got \(error) instead")
            }
            
            XCTAssertEqual(receivedMessage, message)
        }
    }
    
    func test_map_getEmptyResultOn200HTTPCodeAndEmptyJSON() throws {
        let json = makeJSON([])
        
        let result = try RemoteStockSummaryDataMapper.map(json, HTTPURLResponse(statusCode: 200))
        
        XCTAssertEqual(result.count, 0)
    }
    
    func test_map_getResultOn200HTTPCodeAndNotEmptyJSON() throws {
        let item1 = makeItem(
            symbol: "^GSPC",
            shortName: "S&P 500",
            time: 1778684490,
            previousPrice: 7400.96,
            currentPrice: 7413.06
        )
        let item2 = makeItem(
            symbol: "^DJI",
            shortName: "Dow Jones Industrial Average",
            time: 1778684491,
            previousPrice: 49760.56,
            currentPrice: 49892.41
        )
        let json = makeJSON([item1.json, item2.json])
        
        let result = try RemoteStockSummaryDataMapper.map(json, HTTPURLResponse(statusCode: 200))
        
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result[0], item1.model)
        XCTAssertEqual(result[1], item2.model)
    }
    
    //MARK: - Helpers
    
    private func makeItem(symbol: String,
                          shortName: String,
                          time: Int,
                          previousPrice: Double,
                          currentPrice: Double) -> (model: StockItem, json: [String: Any]) {
        let model = StockItem(
            symbol: symbol,
            shortName: shortName,
            time: time,
            previousPrice: previousPrice,
            currentPrice: currentPrice
        )
        let json: [String: Any] = [
            "symbol": symbol,
            "shortName": shortName,
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
    
    private func makeJSON(_ items: [[String: Any]], error: String? = nil) -> Data {
        let json: [String: Any] = [
            "marketSummaryAndSparkResponse": [
                "result": items,
                "error": jsonValue(error)
            ]
        ]
        return try! JSONSerialization.data(withJSONObject: json)
    }
}
