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
    @State private var viewModel: StockListViewModel
    
    init(viewModel: StockListViewModel) {
        self._viewModel = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        List(viewModel.stocks) { stock in
            Button {
                openStockDetails(stock)
            } label: {
                StockListItemView(model: .init(stock: stock))
            }
            .buttonStyle(.plain)
        }
        .overlay {
            if viewModel.stocks.isEmpty {
                emptyView()
            }
        }
        .safeAreaInset(edge: .bottom) {
            if let message = viewModel.errorMessage {
                errorView(message)
            }
        }
        .refreshable {
            await viewModel.loadStocks()
        }
        .navigationTitle("Stocks")
        .searchable(text: $viewModel.searchText,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: "Search by name")
        .task {
            viewModel.startUpdates()
        }
    }
    
    private func emptyView() -> some View {
        ContentUnavailableView("No Stocks",
                               systemImage: "magnifyingglass",
                               description: Text("Try another search."))
    }
    
    private func errorView(_ errorMessage: String) -> some View {
        Text(errorMessage)
            .font(.footnote)
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
            .background(.bar)
    }
    
    private func openStockDetails(_ stock: StockItem) {
        router.push(.stockDetails(stock))
    }
}

#Preview {
    StockMarketContainerView()
}
