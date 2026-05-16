//
//  StockListViewTests.swift
//  StockMarket
//
//  Created by Yury Ramazanov on 16.05.2026.
//

import XCTest
import SwiftUI
import StockMonitor
@testable import StockMarket

@MainActor
final class StockListViewTests: XCTestCase {
    
    func test_showView_startsAutoUpdateAndReloadData() async throws {
        let (sut, viewModel, loader) = makeSUT()
        
        try show(sut)
        await fulfillment(of: [loader.updateStarted], timeout: 1.0)
        
        var result: Result<[StockItem], Error> = .success([anyStockItem()])
        loader.send(result)
        await expect(viewModel, load: result)
    
        result = .success([anyStockItem(), anyStockItem(), anyStockItem()])
        loader.send(result)
        await expect(viewModel, load: result)
        
        let stocks = viewModel.stocks
        let error = anyNSError()
        result = .failure(error)
        loader.send(result)
        await expect(viewModel, load: result)
        
        XCTAssertEqual(viewModel.stocks, stocks)
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: some View, viewModel: StockListViewModel, loader: StockLoaderSpy) {
        let service = DummyStockService()
        let loader = StockLoaderSpy()
        let viewModel = StockListViewModel(service: service, loader: loader)
        let sut = StockListView(viewModel: viewModel)
            .environment(NavigationRouter<StockRoutes>())
        
        return (sut, viewModel, loader)
    }
    
    private func expect(
        _ viewModel: StockListViewModel,
        load result: Result<[StockItem], Error>,
        timeout: TimeInterval = 1,
        file: StaticString = #filePath,
        line: UInt = #line
    ) async {
        let maxDate = Date() + timeout
        
        switch result {
        case let .success(stocks):
            while viewModel.stocks != stocks, Date() <= maxDate {
                await Task.yield()
            }
            XCTAssertNil(viewModel.errorMessage, file: file, line: line)
            XCTAssertEqual(viewModel.stocks, stocks, file: file, line: line)
            
        case .failure:
            while viewModel.errorMessage == nil, Date() <= maxDate {
                await Task.yield()
            }
            XCTAssertNotNil(viewModel.errorMessage, file: file, line: line)
        }
    }
}

private final class StockLoaderSpy: StockLoader {
    let updateStarted = XCTestExpectation(description: "Wait for update")
    private var continuation: AsyncStream<Result<[StockItem], Error>>.Continuation?
    
    func stockUpdates(region: String) -> AsyncStream<Result<[StockItem], Error>> {
        return AsyncStream { continuation in
            self.continuation = continuation
        }
    }
    
    func startStockUpdates(region: String) {
        updateStarted.fulfill()
    }
    
    func stopStockUpdates(region: String) {}
    
    func send(_ result: Result<[StockItem], Error>) {
        continuation?.yield(result)
    }
}

private class DummyStockService: StocksService {
    func getStocks(region: String) async throws -> [StockItem] {
        return []
    }
}
