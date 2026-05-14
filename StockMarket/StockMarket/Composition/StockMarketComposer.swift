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
    private let apiKey = "9aebe50b15msh003af9ba57fd9edp1091f4jsnb38c136f2c95"
    
    private lazy var service: StockService = {
        let service = StockService(baseURL: baseUrl, client: URLSessionHTTPClient())
        service.requestAdapter = ApiKeyRequestAdapter(apiKey: apiKey)
        return service
    }()
    
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
        let model = StockDetailViewModel(stock: item, service: service)
        return StockDetailView(viewModel: model)
    }
    
    private func makeStockListView() -> StockListView {
        let service = StockService(baseURL: baseUrl, client: URLSessionHTTPClient())
        service.requestAdapter = ApiKeyRequestAdapter(apiKey: apiKey)
        let model = StockListViewModel(service: service)
        
        return StockListView(viewModel: model)
    }
}
