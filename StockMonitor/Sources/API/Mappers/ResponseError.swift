//
//  ResponseError.swift
//  StockMonitor
//
//  Created by Yury Ramazanov on 13.05.2026.
//

import Foundation

public struct ResponseError: Error, Decodable {
    public let message: String
}
