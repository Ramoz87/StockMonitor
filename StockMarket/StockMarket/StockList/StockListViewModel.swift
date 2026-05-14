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
   
    enum State {
        case loading
        case updated([StockItem])
        case error(String)
    }
    
    private let service: StockService
    private var stocks = [StockItem]()
    private var tasks = [Region: Task<Void, Never>]()
    
    private(set) var state: State = .updated([])
    private var showLoadingState: Bool {
        if stocks.isEmpty {
            return true
        }
        
        if case .error = state {
            return true
        }
        
        return false
    }
    
    var searchText = "" {
        didSet {
            guard case .updated = state else { return }
            state = .updated(stocksMatchingSearch())
        }
    }
    
    init(service: StockService) {
        self.service = service
    }
    
    func loadStocks(region: Region = .US) {
        for taskRegion in tasks.keys where taskRegion != region {
            tasks[taskRegion]?.cancel()
            tasks[taskRegion] = nil
        }
        
        if tasks[region] != nil {
            return
        }
        
        if showLoadingState {
            state = .loading
        }
        
        let task = Task { [weak self] in
            guard let self else { return }
            
            defer {
                self.tasks[region] = nil
            }
            
            do {
                let stocks = try await service.getStocks(region: region)
                guard !Task.isCancelled else { return }
                
                self.stocks = stocks
                self.state = .updated(self.stocksMatchingSearch())
            } catch {
                guard !Task.isCancelled else { return }
                self.state = .error(error.localizedDescription)
            }
        }
        
        tasks[region] = task
    }
    
    private func stocksMatchingSearch() -> [StockItem] {
        guard !searchText.isEmpty else {
            return stocks
        }
        
        return stocks.filter { stock in
            stock.shortName.localizedStandardContains(searchText)
        }
    }
}
