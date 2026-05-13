//
//  HTTPClient.swift
//  StockMonitor
//
//  Created by Yury Ramazanov on 13.05.2026.
//

import Foundation

public protocol HTTPClient {
    func send(request: URLRequest) async throws -> (Data, HTTPURLResponse)
}
