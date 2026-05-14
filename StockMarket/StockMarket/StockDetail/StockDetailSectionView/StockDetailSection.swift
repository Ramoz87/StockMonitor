//
//  StockDetailSection.swift
//  StockMarket
//
//  Created by Yury Ramazanov on 14.05.2026.
//


struct StockDetailSection: Equatable, Hashable, Identifiable {
    let title: String
    let metrics: [StockDetailMetric]
    
    var id: String { title }
}
