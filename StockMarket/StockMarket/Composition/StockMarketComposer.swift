//
//  StockMarketComposer.swift
//  StockMarket
//
//  Created by Yury Ramazanov on 14.05.2026.
//

import SwiftUI
import StockMonitor

final class StockMarketComposer {
    
    private let baseUrl = URL(string: "https://apidojo-yahoo-finance-v1.p.rapidapi.com")!
    private let apiKey = "2fbe6974f5msh489e387fc59fe24p1bed8cjsn2b98d813f544"
    
    private lazy var service: StockService = {
        let service = StockService(baseURL: baseUrl,
                                   client: URLSessionHTTPClient(),
                                   adapter: ApiKeyRequestAdapter(apiKey: apiKey))
        return service
    }()
    
    private lazy var loader: StockLoader = IntervalStockLoader(service: service, interval: .seconds(8))
    
    var rootView: some View {
        makeView(for: .stocks)
    }
    
    @ViewBuilder
    func makeView(for route: StockRoutes) -> some View {
        switch route {
        case .stocks:
            makeStockListView()
        case .stockDetails(let stock):
            makeStockDetailsView(stock)
        }
    }
    
    private func makeStockDetailsView(_ item: StockItem) -> StockDetailView {
        let model = StockDetailViewModel(stock: item, service: service, loader: loader)
        return StockDetailView(viewModel: model)
    }
    
    private func makeStockListView() -> StockListView {
        let model = StockListViewModel(service: service, loader: loader)
        return StockListView(viewModel: model)
    }
}
