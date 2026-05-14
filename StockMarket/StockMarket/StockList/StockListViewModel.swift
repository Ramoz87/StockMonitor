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
   
    private let service: StockService
    private var loadedStocks: [StockItem] = [] {
        didSet {
            stocks = stocksMatchingSearch()
        }
    }
    private var tasks = [String: Task<Void, Never>]()
    
    private(set) var errorMessage: String? = nil
    private(set) var stocks = [StockItem]()
    
    var searchText = "" {
        didSet {
            stocks = stocksMatchingSearch()
        }
    }
    
    init(service: StockService) {
        self.service = service
    }
    
    func loadStocks(region: String = "US") async {
        for taskRegion in tasks.keys where taskRegion != region {
            tasks[taskRegion]?.cancel()
            tasks[taskRegion] = nil
        }
        
        if let task = tasks[region] {
            return await task.value
        }
                
        let task = Task { [weak self] in
            guard let self else { return }
            
            defer {
                tasks[region] = nil
            }
            
            do {
                let stocks = try await service.getStocks(region: region)
                guard !Task.isCancelled else { return }
                loadedStocks = stocks
                errorMessage = nil
            } catch {
                guard !Task.isCancelled else { return }
                errorMessage = error.localizedDescription
            }
        }
        tasks[region] = task
        
        return await task.value
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
