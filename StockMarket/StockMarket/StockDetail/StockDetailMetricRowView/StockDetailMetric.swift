//
//  StockDetailMetric.swift
//  StockMarket
//
//  Created by Yury Ramazanov on 14.05.2026.
//


struct StockDetailMetric: Equatable, Hashable, Identifiable {
    var id: String { title }

    let title: String
    let value: String
}
