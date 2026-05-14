//
//  StockService.swift
//  StockMonitor
//
//  Created by Yury Ramazanov on 14.05.2026.
//

import Foundation

public final class StockService {
    private let baseURL: URL
    private let client: HTTPClient
    public var requestAdapter: APIRequestAdapter?
    
    public init(baseURL: URL, client: HTTPClient) {
        self.baseURL = baseURL
        self.client = client
    }
        
    public func getStocks(region: String) async throws -> [StockItem] {
        let (data, response) = try await sendRequest(for: .summary(region: region))
        return try RemoteStockSummaryDataMapper.map(data, response)
    }
    
    public func getStockDetails(region: String, symbol: String) async throws -> StockItemDetails? {
        let (data, response) = try await sendRequest(for: .quotes(region: region, symbol: symbol))
        return try RemoteStockDetailsDataMapper.map(data, response)
    }
    
    private func sendRequest(for endpoint: APIEndpoint) async throws -> (Data, HTTPURLResponse) {
        let url = endpoint.url(baseURL: baseURL)
        var request = URLRequest(url: url)
        
        if let requestAdapter {
            request = requestAdapter.adaptRequest(request)
        }
        
        return try await client.send(request: request)
    }
}
