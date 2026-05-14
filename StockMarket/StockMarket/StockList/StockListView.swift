//
//  StockListView.swift
//  StockMarket
//
//  Created by Yury Ramazanov on 14.05.2026.
//

import SwiftUI
import StockMonitor

struct StockListView: View {
    @Environment(NavigationRouter<StockRoutes>.self) private var router
    @State private var isLoading = true
    @State private var viewModel: StockListViewModel
    
    init(viewModel: StockListViewModel) {
        self._viewModel = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        @Bindable var viewModel = viewModel
        
        Group {
            if isLoading && viewModel.stocks.isEmpty {
                ProgressView()
            } else if let errorMessage = viewModel.errorMessage {
                errorView(errorMessage)
            } else {
                listView(viewModel.stocks)
                    .overlay {
                        if viewModel.stocks.isEmpty {
                            emptyView()
                        }
                    }
                    .refreshable {
                        await viewModel.loadStocks()
                    }
                    
            }
        }
        .navigationTitle("Stocks")
        .searchable(text: $viewModel.searchText,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: "Search by name")
        .task {
            await loadInitialData()
        }
    }
    
    private func loadInitialData() async {
        isLoading = true
        await viewModel.loadStocks()
        isLoading = false
    }
    
    private func emptyView() -> some View {
        ContentUnavailableView("No Stocks",
                               systemImage: "magnifyingglass",
                               description: Text("Try another search."))
    }
    
    private func errorView(_ errorMessage: String) -> some View {
        ContentUnavailableView("Could Not Load Stocks",
                               systemImage: "exclamationmark.triangle",
                               description: Text(errorMessage))
    }
    
    private func listView(_ stocks: [StockItem]) -> some View {
        List(stocks) { stock in
            Button {
                openStockDetails(stock)
            } label: {
                StockListItemView(model: .init(stock: stock))
            }
            .buttonStyle(.plain)
        }
    }
    
    private func openStockDetails(_ stock: StockItem) {
        router.push(.stockDetails(stock))
    }
}

#Preview {
    StockMarketContainerView()
}
