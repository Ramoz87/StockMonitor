//
//  RemoteStockDetailsDataMapper.swift
//  StockMonitor
//
//  Created by Yury Ramazanov on 13.05.2026.
//

import Foundation

final class RemoteStockDetailsDataMapper {
    
    enum Error: Swift.Error {
        case invalidData
        case apiError(String)
    }

    static func map(_ data: Data, _ response: HTTPURLResponse) throws -> StockItemDetails? {
        guard response.isOK else {
            if let error = try? JSONDecoder().decode(ResponseError.self, from: data) {
                throw error
            }
            throw Error.invalidData
        }
        
        guard let result = try? JSONDecoder().decode(StockQuoteResponse.self, from: data) else {
            throw Error.invalidData
        }
        
        if let error = result.quoteResponse.error {
            throw Error.apiError(error)
        }
        
        guard let firstQuote = result.quoteResponse.result.first else {
            return nil
        }
        
        return firstQuote.stockDetails
    }
}
