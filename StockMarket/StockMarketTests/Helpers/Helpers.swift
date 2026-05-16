//
//  Helpers.swift
//  StockMonitor
//
//  Created by Yury Ramazanov on 13.05.2026.
//

import Foundation
import XCTest
import UIKit
import SwiftUI
import StockMonitor

func anyURL() -> URL {
    return URL(string: "http://any-url.com")!
}

func anyNSError() -> NSError {
    NSError(domain: "any error", code: 0)
}

extension HTTPURLResponse {
    convenience init(statusCode: Int) {
        self.init(url: anyURL(), statusCode: statusCode, httpVersion: nil, headerFields: nil)!
    }
}

func anyStockItem() -> StockItem {
    return StockItem(
        symbol: "AAPL",
        shortName: "Any Short Name",
        region: "US",
        time: 1,
        previousPrice: 100,
        currentPrice: 101
    )
}

@discardableResult
func show(_ view: some View) throws -> UIWindow {
    let windowScene = try XCTUnwrap(UIApplication.shared.connectedScenes
        .compactMap { $0 as? UIWindowScene }
        .first)
    let window = UIWindow(windowScene: windowScene)
    window.rootViewController = UIHostingController(rootView: view)
    window.makeKeyAndVisible()
    return window
}
