//
//  HTTPClientSpy.swift
//  StockMonitor
//
//  Created by Yury Ramazanov on 14.05.2026.
//

import Foundation
import StockMonitor

final class HTTPClientSpy: HTTPClient {
    private let result: Result<(Data, HTTPURLResponse), Error>
    private(set) var requests = [URLRequest]()
    
    init(result: Result<(Data, HTTPURLResponse), Error>) {
        self.result = result
    }
    
    func send(request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        requests.append(request)
        return try result.get()
    }
}
