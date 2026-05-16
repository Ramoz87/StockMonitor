//
//  StockMarketContainerView.swift
//  StockMarket
//
//  Created by Yury Ramazanov on 14.05.2026.
//

import SwiftUI

struct StockMarketContainerView: View {
    @State private var router = NavigationRouter<StockRoutes>()
    private let composer = StockMarketComposer()
    
    var body: some View {
        NavigationStack(path: $router.path) {
            composer.rootView
                .navigationDestination(for: StockRoutes.self) { route in
                    composer.makeView(for: route)
                }
        }
        .environment(router)
    }
}
