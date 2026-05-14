//
//  StockService.swift
//  StockMonitor
//
//  Created by Yury Ramazanov on 14.05.2026.
//

import Foundation

let baseUrl = "https://apidojo-yahoo-finance-v1.p.rapidapi.com"
public final class StockService {
    private let baseURL: URL
    private let client: HTTPClient
    
    public init(baseURL: URL, client: HTTPClient) {
        self.baseURL = baseURL
        self.client = client
    }
    
    public convenience init(client: HTTPClient) {
        self.init(baseURL: URL(string: baseUrl)!, client: client)
    }
    
    public func getStocks(region: Region) async throws -> [StockItem] {
        let (data, response) = try await sendRequest(for: .summary(region: region))
        return try RemoteStockSummaryDataMapper.map(data, response)
    }
    
    public func getStockDetails(region: Region, symbol: String) async throws -> StockItemDetails? {
        let (data, response) = try await sendRequest(for: .quotes(region: region, symbol: symbol))
        return try RemoteStockDetailsDataMapper.map(data, response)
    }
    
    private func sendRequest(for endpoint: APIEndpoint) async throws -> (Data, HTTPURLResponse) {
        let url = endpoint.url(baseURL: baseURL)
        let request = URLRequest(url: url)
        return try await client.send(request: request)
    }
}
