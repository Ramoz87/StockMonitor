//
//  StockDetailSectionView.swift
//  StockMarket
//
//  Created by Yury Ramazanov on 14.05.2026.
//

import SwiftUI

struct StockDetailSectionView: View {
    let section: StockDetailSection

    var body: some View {
        Section {
            VStack {
                ForEach(section.metrics) { metric in
                    StockDetailMetricRowView(metric: metric)
                    Divider()
                }
            }
            .padding()
            .background(.background.secondary, in: .rect(cornerRadius: 8))
        } header: {
            Text(section.title)
                .font(.headline)
                .padding(.top)
        }
    }
}
