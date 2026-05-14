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
    
    let stock: StockItem
    private let service: StockService
    private var task: Task<Void, Never>?
    
    private(set) var errorMessage: String? = nil
    private(set) var sections: [StockDetailSection] = []

    init(stock: StockItem, service: StockService) {
        self.stock = stock
        self.service = service
    }

    func loadDetails() async {
        if let task {
            return await task.value
        }

        task = Task { [weak self] in
            guard let self else { return }

            defer {
                self.task = nil
            }

            do {
                let details = try await service.getStockDetails(region: stock.region, symbol: stock.symbol)
                guard !Task.isCancelled else { return }
                sections = details?.toSections ?? []
                errorMessage = nil
            } catch {
                guard !Task.isCancelled else { return }
                errorMessage = error.localizedDescription
            }
        }

        await task?.value
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
