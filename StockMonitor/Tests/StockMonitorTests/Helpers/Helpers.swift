//
//  Helpers.swift
//  StockMonitor
//
//  Created by Yury Ramazanov on 13.05.2026.
//

import Foundation

func anyURL() -> URL {
    return URL(string: "http://any-url.com")!
}

func jsonValue<T>(_ value: T?) -> Any {
    return value.map { $0 as Any } ?? NSNull()
}

func makeErrorJSON(message: String) -> Data {
    let json = [
        "message": message
    ]
    return try! JSONSerialization.data(withJSONObject: json)
}

extension HTTPURLResponse {
    convenience init(statusCode: Int) {
        self.init(url: anyURL(), statusCode: statusCode, httpVersion: nil, headerFields: nil)!
    }
}
