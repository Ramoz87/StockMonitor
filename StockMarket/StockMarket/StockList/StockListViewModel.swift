//
//  StockListViewModel.swift
//  StockMarket
//
//  Created by Yury Ramazanov on 14.05.2026.
//

import Foundation
import Observation
import StockMonitor

@Observable
final class StockListViewModel {
    
    private let region = "US"
    private let loader: StockLoader
    private let service: StocksService
    private var loadedStocks: [StockItem] = [] {
        didSet {
            stocks = stocksMatchingSearch()
        }
    }
    
    private(set) var errorMessage: String?
    private(set) var stocks = [StockItem]()
    
    private var updateTask: Task<Void, Never>?
    
    var searchText = "" {
        didSet {
            stocks = stocksMatchingSearch()
        }
    }
    
    deinit {
        updateTask?.cancel()
    }
    
    init(service: StocksService, loader: StockLoader) {
        self.loader = loader
        self.service = service
    }
    
    func loadStocks() async {
        do {
            let stocks = try await service.getStocks(region: region)
            updateState(result: .success(stocks))
        } catch {
            updateState(result: .failure(error))
        }
    }
    
    func startUpdates() {
        loader.startStockUpdates(region: region)
    
        updateTask = Task {
            for await result in loader.stockUpdates(region: region) {
                updateState(result: result)
            }
        }
    }
    
    private func updateState(result: Result<[StockItem], Error>) {
        switch result {
        case .success(let stocks):
            loadedStocks = stocks
            errorMessage = nil
        case .failure(let error):
            errorMessage = error.localizedDescription
        }
    }
    
    private func stocksMatchingSearch() -> [StockItem] {
        guard !searchText.isEmpty else {
            return loadedStocks
        }
        
        return loadedStocks.filter { stock in
            stock.shortName.localizedStandardContains(searchText)
        }
    }
}

protocol StocksService {
   func getStocks(region: String) async throws -> [StockItem]
}
