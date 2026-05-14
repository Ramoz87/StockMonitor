//
//  NavigationRouter.swift
//  StockMarket
//
//  Created by Yury Ramazanov on 14.05.2026.
//

import Observation

@Observable
final class NavigationRouter<Route: Hashable> {
    var path = [Route]()

    func push(_ route: Route) {
        path.append(route)
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
}
