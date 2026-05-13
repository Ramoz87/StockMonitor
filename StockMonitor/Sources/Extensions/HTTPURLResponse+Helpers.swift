//
//  File.swift
//  StockMonitor
//
//  Created by Yury Ramazanov on 13.05.2026.
//

import Foundation

extension HTTPURLResponse {
    var isOK: Bool {
        return (200...299).contains(statusCode)
    }
}
