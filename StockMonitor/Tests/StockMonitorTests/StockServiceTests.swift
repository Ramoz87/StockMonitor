//
//  StockServiceTests.swift
//  StockMonitor
//
//  Created by Yury Ramazanov on 14.05.2026.
//

import XCTest
@testable import StockMonitor

final class StockServiceTests: XCTestCase {
    
    func test_getStocks_requestsSummaryEndpoint() async throws {
        let baseURL = URL(string: "http://base-url.com")!
        let region = Region.ES
        let (sut, client) = makeSUT(baseURL: baseURL, result: successResult(makeStocksJSON([])))
        
        _ = try await sut.getStocks(region: region)
        
        XCTAssertEqual(client.requests.count, 1)
        XCTAssertEqual(client.requests[0].url?.scheme, "http")
        XCTAssertEqual(client.requests[0].url?.host, "base-url.com")
        XCTAssertEqual(client.requests[0].url?.path, "/market/v2/get-summary")
        XCTAssertEqual(client.requests[0].url?.query(), "region=\(region.rawValue)")
    }
    
    func test_getStocks_deliversMappedStocks() async throws {
        let item = makeStockItem(
            symbol: "^GSPC",
            shortName: "S&P 500",
            time: 1778684490,
            previousPrice: 7400.96,
            currentPrice: 7413.06
        )
        let json = makeStocksJSON([item.json])
        let (sut, _) = makeSUT(result: successResult(json))
        
        let result = try await sut.getStocks(region: .US)
        
        XCTAssertEqual(result, [item.model])
    }
    
    func test_getStocks_deliversClientError() async {
        let error = anyNSError()
        let (sut, _) = makeSUT(result: .failure(error))
        
        await XCTAssertThrowsErrorAsync(try await sut.getStocks(region: .US)) { receivedError in
            XCTAssertEqual(receivedError as NSError, error)
        }
    }
    
    
    func test_getStockDetails_requestsQuotesEndpoint() async throws {
        let baseURL = URL(string: "http://base-url.com")!
        let region = Region.ES
        let symbol = "AAPL"
        let (sut, client) = makeSUT(baseURL: baseURL, result: successResult(makeStockDetailsJSON([])))
        
        _ = try await sut.getStockDetails(region: region, symbol: symbol)
        
        XCTAssertEqual(client.requests.count, 1)
        XCTAssertEqual(client.requests[0].url?.scheme, "http")
        XCTAssertEqual(client.requests[0].url?.host, "base-url.com")
        XCTAssertEqual(client.requests[0].url?.path, "/market/v2/get-quotes")
        XCTAssertEqual(client.requests[0].url?.query?.contains("region=\(region.rawValue)"), true)
        XCTAssertEqual(client.requests[0].url?.query?.contains("symbols=\(symbol)"), true)
    }
    
    func test_getStockDetails_deliversMappedStockDetails() async throws {
        let symbol = "AAPL"
        let item = makeStockDetailsItem(
            symbol: symbol,
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
        let json = makeStockDetailsJSON([item.json])
        let (sut, _) = makeSUT(result: successResult(json))
        
        let result = try await sut.getStockDetails(region: .US, symbol: symbol)
        
        XCTAssertEqual(result, item.model)
    }
    
    func test_getStockDetails_deliversClientError() async {
        let error = anyNSError()
        let (sut, _) = makeSUT(result: .failure(error))
        
        await XCTAssertThrowsErrorAsync(try await sut.getStockDetails(region: .US, symbol: "AAPL")) { receivedError in
            XCTAssertEqual(receivedError as NSError, error)
        }
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        baseURL: URL = anyURL(),
        result: Result<(Data, HTTPURLResponse), Error>
    ) -> (sut: StockService, client: HTTPClientSpy) {
        let client = HTTPClientSpy(result: result)
        let sut = StockService(baseURL: baseURL, client: client)
        return (sut, client)
    }
    
    private func successResult(_ data: Data) -> Result<(Data, HTTPURLResponse), Error> {
        return .success((data, HTTPURLResponse(statusCode: 200)))
    }
        
    private func XCTAssertThrowsErrorAsync<T>(
        _ expression: @autoclosure () async throws -> T,
        _ message: @autoclosure () -> String = "",
        file: StaticString = #filePath,
        line: UInt = #line,
        _ errorHandler: (_ error: Error) -> Void = { _ in }
    ) async {
        do {
            _ = try await expression()
            XCTFail(message(), file: file, line: line)
        } catch {
            errorHandler(error)
        }
    }
}
