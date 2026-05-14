//
//  StockListView.swift
//  StockMarket
//
//  Created by Yury Ramazanov on 14.05.2026.
//

import SwiftUI
import StockMonitor

struct StockListView: View {
    @State private var viewModel: StockListViewModel
    
    init(viewModel: StockListViewModel) {
        self._viewModel = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        @Bindable var viewModel = viewModel
        
        NavigationStack {
            Group {
                switch viewModel.state {
                case .loading:
                    ProgressView()
                    
                case .updated(let stocks):
                    List(stocks) {
                        StockListItemView(stock: $0)
                    }
                    .overlay {
                        if stocks.isEmpty {
                            ContentUnavailableView("No Stocks",
                                                   systemImage: "magnifyingglass",
                                                   description: Text("Try another search."))
                        }
                    }
                    
                case .error(let errorMessage):
                    ContentUnavailableView("Could Not Load Stocks",
                                           systemImage: "exclamationmark.triangle",
                                           description: Text(errorMessage))
                }
            }
            .navigationTitle("Stocks")
            .searchable(text: $viewModel.searchText,
                        placement: .navigationBarDrawer(displayMode: .always),
                        prompt: "Search by name")
            .task {
                viewModel.loadStocks()
            }
        }
    }
}

#Preview {
    ContentView()
}
