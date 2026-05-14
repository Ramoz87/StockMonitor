//
//  ContentView.swift
//  StockMarket
//
//  Created by Yury Ramazanov on 14.05.2026.
//

import SwiftUI
import StockMonitor

struct ContentView: View {
    var body: some View {
        makeStockListView()
    }
    
    func makeStockListView() -> some View {
        let baseUrl = URL(string: "https://apidojo-yahoo-finance-v1.p.rapidapi.com")!
        let service = StockService(baseURL: baseUrl, client: URLSessionHTTPClient())
        service.requestAdapter = ApiKeyRequestAdapter(apiKey: "9aebe50b15msh003af9ba57fd9edp1091f4jsnb38c136f2c95")
        let model = StockListViewModel(service: service)
        return StockListView(viewModel: model)
    }
}

#Preview {
    ContentView()
}
