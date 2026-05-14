//
//  StockDetailView.swift
//  StockMarket
//
//  Created by Yury Ramazanov on 14.05.2026.
//

import SwiftUI
import StockMonitor

struct StockDetailView: View {
    @State private var isLoading = true
    private let viewModel: StockDetailViewModel
    
    init(viewModel: StockDetailViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                StockDetailSummaryView(model: .init(stock: viewModel.stock))
                
                if isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                }
                
                if let errorMessage = viewModel.errorMessage {
                    errorView(errorMessage)
                } else {
                    sectionsView()
                }
            }
            .padding()
        }
        .navigationTitle(viewModel.stock.shortName)
        .navigationBarTitleDisplayMode(.inline)
        .refreshable {
            await viewModel.loadDetails()
        }
        .task {
            await loadInitialData()
        }
    }
    
    private func loadInitialData() async {
        isLoading = true
        await viewModel.loadDetails()
        isLoading = false
    }
    
    private func errorView(_ errorMessage: String) -> some View {
        ContentUnavailableView("Could Not Load Stocks",
                               systemImage: "exclamationmark.triangle",
                               description: Text(errorMessage))
    }
    
    private func sectionsView() -> some View {
        ForEach(viewModel.sections) { section in
            StockDetailSectionView(section: section)
        }
    }
}
