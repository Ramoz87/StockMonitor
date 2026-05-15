//
//  APIEndpointTests.swift
//  StockMonitor
//
//  Created by Yury Ramazanov on 13.05.2026.
//

import XCTest
import StockMonitor

class APIEndpointTests: XCTestCase {
    
    func test_summary_endpointURL() {
        let baseURL = URL(string: "http://base-url.com")!
        let region = "US"
        let url = APIEndpoint.summary(region: region).url(baseURL: baseURL)
        
        XCTAssertEqual(url.scheme, "http")
        XCTAssertEqual(url.host, "base-url.com")
        XCTAssertEqual(url.path, "/market/v2/get-summary")
        XCTAssertEqual(url.query(), "region=\(region)")
    }
    
    func test_quotes_endpointURL() {
        let baseURL = URL(string: "http://base-url.com")!
        let region = "US"
        let symbol = "AAPL"
        let url = APIEndpoint.quotes(region: region, symbol: symbol).url(baseURL: baseURL)
        
        XCTAssertEqual(url.scheme, "http")
        XCTAssertEqual(url.host, "base-url.com")
        XCTAssertEqual(url.path, "/market/v2/get-quotes")
        XCTAssertEqual(url.query?.contains("region=\(region)"), true)
        XCTAssertEqual(url.query?.contains("symbols=\(symbol)"), true)
    }
}
