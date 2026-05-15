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
        let message = "a response error"
        let json = makeErrorJSON(message: message)
        let codes = [199, 300, 400, 500]
    
        try codes.forEach { code in
            XCTAssertThrowsError(
                try RemoteStockDetailsDataMapper.map(json, HTTPURLResponse(statusCode: code))
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
        XCTAssertThrowsError (
            try RemoteStockDetailsDataMapper.map(json, HTTPURLResponse(statusCode: 200))
        )
    }
    
    func test_map_getEmptyResultOn200HTTPCodeAndEmptyJSON() throws {
        let json = makeStockDetailsJSON([])
        let result = try RemoteStockDetailsDataMapper.map(json, HTTPURLResponse(statusCode: 200))
        XCTAssertEqual(result, nil)
    }
    
    func test_map_getResultOn200HTTPCodeAndNotEmptyJSON() throws {
        let item = makeStockDetailsItem(
            symbol: "AAPL",
            previousClose: 448.29,
            open: 457.595,
            dayLow: 432.65,
            dayHigh: 459.5,
            volume: 9690920,
            averageVolume: 39315288,
            fiftyTwoWeekLow: 107.67,
            fiftyTwoWeekHigh: 469.22,
            fiftyDayAverage: 264.676,
            twoHundredDayAverage: 220.2454,
            currency: "USD"
        )
        let json = makeStockDetailsJSON([item.json])
        
        let result = try RemoteStockDetailsDataMapper.map(json, HTTPURLResponse(statusCode: 200))
        
        XCTAssertEqual(result, item.model)
    }
    
    func test_map_throwErrorOn200HTTPCodeAndNotEmptyError() throws {
        let message = "an error"
        let json = makeStockDetailsJSON([], error: message)
        
        XCTAssertThrowsError(
            try RemoteStockDetailsDataMapper.map(json, HTTPURLResponse(statusCode: 200))
        ) { error in
            guard case let RemoteStockDetailsDataMapper.Error.apiError(receivedMessage) = error else {
                return XCTFail("Expected apiError(\(message)), got \(error) instead")
            }
            
            XCTAssertEqual(receivedMessage, message)
        }
    }
}
