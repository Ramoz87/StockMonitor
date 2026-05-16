//
//  HTTPClientSpy.swift
//  StockMarket
//
//  Created by Yury Ramazanov on 16.05.2026.
//

import Foundation
import StockMonitor

class HTTPClientSpy: HTTPClient {
    private var results: [Result<(Data, HTTPURLResponse), Error>]
    private(set) var requests = [URLRequest]()
    var count: Int {
        requests.count
    }
    
    init(results: [Result<(Data, HTTPURLResponse), Error>]) {
        self.results = results
    }
    
    func send(request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        requests.append(request)
        
        if results.count > 1 {
            return try results.removeFirst().get()
        }
        return try results[0].get()
    }
}
