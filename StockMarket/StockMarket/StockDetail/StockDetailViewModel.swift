//
//  StockDetailViewModel.swift
//  StockMarket
//
//  Created by Yury Ramazanov on 14.05.2026.
//

import Foundation
import Observation
import StockMonitor

@Observable
final class StockDetailViewModel {
    
    private(set) var stock: StockItem
    private let loader: StockLoader
    private let service: StockDetailsService
    private var updateTask: Task<Void, Never>?
    
    private(set) var errorMessage: String? = nil
    private(set) var sections: [StockDetailSection] = []
    
    init(stock: StockItem, service: StockDetailsService, loader: StockLoader) {
        self.stock = stock
        self.loader = loader
        self.service = service
    }
    
    deinit {
        updateTask?.cancel()
    }
    
    func startUpdates() {
        loader.startStockUpdates(region: stock.region)
        
        updateTask = Task {
            for await result in loader.stockUpdates(region: stock.region) {
                guard !Task.isCancelled else { return }
                updateState(result: result)
            }
        }
    }
    
    func loadDetails() async {
        do {
            let details = try await service.getStockDetails(region: stock.region, symbol: stock.symbol)
            sections = details?.toSections ?? []
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    private func updateState(result: Result<[StockItem], Error>) {
        if case .success(let items) = result,
           let item = items.first(where: { $0.symbol == stock.symbol }){
            stock = item
        }
    }
}

private extension StockItemDetails {
    
    var toSections: [StockDetailSection] {
        return [
            StockDetailSection(
                title: "Trading",
                metrics: [
                    StockDetailMetric(title: "Previous Close", value: currency(previousClose, code: currency)),
                    StockDetailMetric(title: "Open", value: currency(open, code: currency)),
                    StockDetailMetric(title: "Day Low", value: currency(dayLow, code: currency)),
                    StockDetailMetric(title: "Day High", value: currency(dayHigh, code: currency))
                ]
            ),
            StockDetailSection(
                title: "Volume",
                metrics: [
                    StockDetailMetric(title: "Volume", value: number(volume)),
                    StockDetailMetric(title: "Average Volume", value: number(averageVolume))
                ]
            ),
            StockDetailSection(
                title: "Averages",
                metrics: [
                    StockDetailMetric(title: "52 Week Low", value: currency(fiftyTwoWeekLow, code: currency)),
                    StockDetailMetric(title: "52 Week High", value: currency(fiftyTwoWeekHigh, code: currency)),
                    StockDetailMetric(title: "50 Day Average", value: currency(fiftyDayAverage, code: currency)),
                    StockDetailMetric(title: "200 Day Average", value: currency(twoHundredDayAverage, code: currency))
                ]
            )
        ]
    }
    
    private func currency(_ value: Double?, code: String?) -> String {
        guard let value else { return "Unavailable" }
        
        if let code {
            return value.formatted(.currency(code: code).precision(.fractionLength(2)))
        } else {
            return value.formatted(.number.precision(.fractionLength(2)))
        }
    }
    
    private func number(_ value: Int64?) -> String {
        guard let value else { return "Unavailable" }
        return value.formatted(.number)
    }
}

protocol StockDetailsService {
    func getStockDetails(region: String, symbol: String) async throws -> StockItemDetails?
}
