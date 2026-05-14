//
//  ResponseError.swift
//  StockMonitor
//
//  Created by Yury Ramazanov on 13.05.2026.
//

import Foundation

public struct ResponseError: LocalizedError, Decodable {
    public let message: String
    
    public var errorDescription: String? {
        message
    }
}
