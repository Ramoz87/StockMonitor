//
//  StockMarketTests.swift
//  StockMarketTests
//
//  Created by Yury Ramazanov on 14.05.2026.
//

import XCTest
import StockMonitor
@testable import StockMarket

@MainActor
final class IntervalStockLoaderTests: XCTestCase {
    
    func test_init_doesNotStartAnyUpdates() async throws {
        let (_, client) = makeSUT(returning: [successResult()])
        XCTAssertEqual(client.count, 0)
    }
    
    func test_startStockUpdates_updteStarted() async throws {
        let region = "US"
        let (sut, _) = makeSUT(returning: [successResult()])
        
        sut.startStockUpdates(region: region)
        var stream = sut.stockUpdates(region: region).makeAsyncIterator()
        let update = try await stream.next()?.get()
        XCTAssertEqual(update, [])
    }
    
    func test_getStocksFailed_updateNotStoped() async throws {
        let region = "US"
        let error = anyNSError()
        let results = [successResult(), .failure(error), successResult()]
        let (sut, _) = makeSUT(returning: results)
        
        var iterator = sut.stockUpdates(region: region).makeAsyncIterator()
        sut.startStockUpdates(region: region)
        
        for result in results {
            let recievedResult = await iterator.next()
            XCTAssertNotNil(recievedResult)
            if case .failure = result {
                assertError(recievedResult!, equals: error)
            } else {
                assertResult(recievedResult!, equals: [])
            }
        }
    }
    
    func test_stopStockUpdates_taskStopped() async throws {
        let region = "US"
        let (sut, _) = makeSUT(returning: [successResult()])
        
        var stream = sut.stockUpdates(region: region).makeAsyncIterator()
        sut.startStockUpdates(region: region)
        let update = try await stream.next()?.get()
        XCTAssertEqual(update, [])
        
        sut.stopStockUpdates(region: region)
        let update1 = await stream.next()
        XCTAssertNil(update1)
    }
    
    func test_stockLoaderDeinit_allTasksFinished() async throws {
        let region = "US"
        var sut:(IntervalStockLoader, HTTPClientSpy)! = makeSUT(returning: [successResult()])
        
        var stream1 = sut.0.stockUpdates(region: region).makeAsyncIterator()
        var stream2 = sut.0.stockUpdates(region: region).makeAsyncIterator()
        
        sut.0.startStockUpdates(region: region)
        var result = await stream1.next()
        XCTAssertNotNil(result)
        result = await stream2.next()
        XCTAssertNotNil(result)
        
        sut = nil
        
        result = await stream1.next()
        XCTAssertNil(result)
        result = await stream2.next()
        XCTAssertNil(result)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        returning result: [Result<(Data, HTTPURLResponse), Error>],
        interval: Duration = .milliseconds(1),
        file: StaticString = #filePath,
        line: UInt = #line
    )  -> (sut: IntervalStockLoader, client: HTTPClientSpy) {
        
        let client = HTTPClientSpy(results: result)
        let service = StockService(baseURL: anyURL(), client: client)
        let loader = IntervalStockLoader(service: service, interval: interval)
        
        trackMemoryLeaks(client, file: file, line: line)
        trackMemoryLeaks(service, file: file, line: line)
        trackMemoryLeaks(loader, file: file, line: line)

        return (loader, client)
    }
         
    private func assertResult(
        _ result: Result<[StockItem], Error>,
        equals expectedStocks: [StockItem],
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        switch result {
        case let .success(stocks):
            XCTAssertEqual(stocks, expectedStocks, file: file, line: line)
        case let .failure(error):
            XCTFail("Expected success, got \(error)", file: file, line: line)
        }
    }
    
    private func assertError(
        _ result: Result<[StockItem], Error>,
        equals expectedError: NSError,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        switch result {
        case let .success(stocks):
            XCTFail("Expected failure, got \(stocks)", file: file, line: line)
        case let .failure(error):
            XCTAssertEqual(error as NSError, expectedError, file: file, line: line)
        }
    }
    
    private func successResult() -> Result<(Data, HTTPURLResponse), Error> {
        return .success((emptyJSON(), HTTPURLResponse(statusCode: 200)))
    }
    
    private func emptyJSON() -> Data {
        return Data(#"{"marketSummaryAndSparkResponse":{"result":[],"error":null}}"#.utf8)
    }
}

private class HTTPClientSpy: HTTPClient {
    private var results: [Result<(Data, HTTPURLResponse), Error>]
    private(set) var count = 0
    
    init(results: [Result<(Data, HTTPURLResponse), Error>]) {
        self.results = results
    }
    
    func send(request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        count += 1
        
        if results.count > 1 {
            return try results.removeFirst().get()
        }
        return try results[0].get()
    }
}
