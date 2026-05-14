//
//  StockRoutes.swift
//  StockMarket
//
//  Created by Yury Ramazanov on 14.05.2026.
//

import StockMonitor

enum StockRoutes: Hashable {
    case stocks
    case stockDetails(StockItem)
}
