//
//  APIRequestAdapter.swift
//  StockMonitor
//
//  Created by Yury Ramazanov on 14.05.2026.
//

import Foundation

public protocol APIRequestAdapter {
    func adaptRequest(_ request: URLRequest) -> URLRequest
}
