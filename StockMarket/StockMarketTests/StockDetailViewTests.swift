//
//  StockDetailViewTests.swift
//  StockMarket
//
//  Created by Yury Ramazanov on 16.05.2026.
//


import XCTest
import UIKit
import SwiftUI
import StockMonitor
@testable import StockMarket

@MainActor
final class StockDetailViewTests: XCTestCase {
    
    func test_showView_requestsStockDetails() async throws {
        let stock = anyStockItem()
        let (sut, service) = makeSUT(stock: stock)
        
        try show(sut)
        await fulfillment(of: [service.requestReceived], timeout: 1.0)
        
        XCTAssertEqual(service.requests.count, 1)
        XCTAssertEqual(service.requests.first?.0, stock.region)
        XCTAssertEqual(service.requests.first?.1, stock.symbol)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(stock: StockItem) -> (sut: StockDetailView, service: StockDetailsServiceSpy) {
        let loader = DummyStockLoader()
        let service = StockDetailsServiceSpy()
        let viewModel = StockDetailViewModel(stock: stock, service: service, loader: loader)
        let sut = StockDetailView(viewModel: viewModel)
        
        return (sut, service)
    }
}

private class StockDetailsServiceSpy: StockDetailsService {
    let requestReceived = XCTestExpectation(description: "Wait for request")
    private(set) var requests: [(String, String)] = []
    
    func getStockDetails(region: String, symbol: String) async throws -> StockItemDetails? {
        requests.append((region, symbol))
        requestReceived.fulfill()
        return nil
    }
}

private class DummyStockLoader: StockLoader {
    func stockUpdates(region: String) -> AsyncStream<Result<[StockItem], Error>> {
        return AsyncStream { continuation in
            continuation.finish()
        }
    }
    
    func startStockUpdates(region: String) {}
    
    func stopStockUpdates(region: String) {}
}
