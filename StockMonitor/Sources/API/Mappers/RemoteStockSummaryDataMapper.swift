//
//  RemoteStockSummaryDataMapper.swift
//  StockMonitor
//
//  Created by Yury Ramazanov on 13.05.2026.
//

import Foundation

final class RemoteStockSummaryDataMapper {
    
    enum Error: Swift.Error {
        case invalidData
        case apiError(String)
    }
    
    static func map(_ data: Data, _ response: HTTPURLResponse) throws -> [StockItem] {
        guard response.isOK, let result = try? JSONDecoder().decode(StockSummaryResponse.self, from: data) else {
            if let error = try? JSONDecoder().decode(ResponseError.self, from: data) {
                throw error
            }
            throw Error.invalidData
        }
        
        if let error = result.marketSummaryAndSparkResponse.error {
            throw Error.apiError(error)
        }
        
        return result.items
    }
}
