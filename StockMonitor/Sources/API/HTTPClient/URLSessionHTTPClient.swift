//
//  URLSessionHTTPClient.swift
//  StockMonitor
//
//  Created by Yury Ramazanov on 13.05.2026.
//

import Foundation

@available(macOS 12.0, *)
public final class URLSessionHTTPClient: HTTPClient {
    private let session: URLSession
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    private struct UnexpectedError: Error {}
    
    public func send(request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        let (data, response) = try await session.data(for: request)
        
        guard let response = response as? HTTPURLResponse else {
            throw UnexpectedError()
        }
        return (data, response)
    }
}
