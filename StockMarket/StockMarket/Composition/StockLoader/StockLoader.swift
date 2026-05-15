//
//  StockLoader.swift
//  StockMarket
//
//  Created by Yury Ramazanov on 14.05.2026.
//

import Foundation
import StockMonitor

protocol StockLoader: AnyObject {
    func stockUpdates(region: String) -> AsyncStream<Result<[StockItem], Error>>
    func startStockUpdates(region: String)
    func stopStockUpdates(region: String)
}
