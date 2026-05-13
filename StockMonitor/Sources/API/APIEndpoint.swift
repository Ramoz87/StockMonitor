//
//  FeedEndpoint.swift
//  StockMonitor
//
//  Created by Yury Ramazanov on 13.05.2026.
//

import Foundation

let baseUrl = "https://apidojo-yahoo-finance-v1.p.rapidapi.com"

public enum APIEndpoint {
        
    case summary(region: Region)
    case quotes(region: Region, symbol: String)
    
    public func url(baseURL: URL) -> URL {
        switch self {
        case .summary(let region):
            url(baseUrl: baseURL,
                path:"/market/v2/get-summary",
                params: ["region" : region.rawValue])
            
        case .quotes(let region, let symbol):
            url(baseUrl: baseURL,
                path: "/market/v2/get-quotes",
                params: ["region" : region.rawValue, "symbols" : symbol])
        }
    }
    
    private func url(baseUrl: URL, path: String, params: [String: String]) -> URL {
        var components = URLComponents()
        components.scheme = baseUrl.scheme
        components.host = baseUrl.host
        components.path = baseUrl.path + path
        components.queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }
        return components.url!
    }
}
