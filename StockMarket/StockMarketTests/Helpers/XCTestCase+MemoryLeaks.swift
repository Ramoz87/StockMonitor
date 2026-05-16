//
//  XCTestCase+MemoryLeaks.swift
//  StockMarket
//
//  Created by Yury Ramazanov on 15.05.2026.
//

import XCTest

extension XCTestCase {
    @MainActor
    func trackMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
}
