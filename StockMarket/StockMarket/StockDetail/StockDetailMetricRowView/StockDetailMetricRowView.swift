//
//  StockDetailMetricRowView.swift
//  StockMarket
//
//  Created by Yury Ramazanov on 14.05.2026.
//

import SwiftUI

struct StockDetailMetricRowView: View {
    let metric: StockDetailMetric

    var body: some View {
        HStack {
            Text(metric.title)
                .foregroundStyle(.secondary)

            Spacer()

            Text(metric.value)
                .foregroundStyle(.tertiary)
        }
        .accessibilityElement(children: .combine)
    }
}
