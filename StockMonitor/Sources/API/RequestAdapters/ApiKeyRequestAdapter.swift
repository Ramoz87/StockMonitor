//
//  ApiKeyRequestAdapter.swift
//  StockMonitor
//
//  Created by Yury Ramazanov on 14.05.2026.
//

import Foundation

public struct ApiKeyRequestAdapter: APIRequestAdapter {
    private let apiKey: String
    
    public init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    public func adaptRequest(_ request: URLRequest) -> URLRequest {
        var request = request
        request.setValue(apiKey, forHTTPHeaderField: "x-rapidapi-key")
        return request
    }
}
