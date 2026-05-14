//
//  StockDetailSummaryView.swift
//  StockMarket
//
//  Created by Yury Ramazanov on 14.05.2026.
//

import SwiftUI

struct StockDetailSummaryView: View {
    let model: StockDetailSummaryViewModel

    var body: some View {
        VStack(alignment: .leading) {
            Text(model.symbol)
                .font(.title)
                .bold()

            HStack {
                Text(model.price, format: .number.precision(.fractionLength(2)))
                    .font(.title2)
                    .bold()

                Label {
                    Text(model.changePercentage, format: .percent.precision(.fractionLength(2)))
                } icon: {
                    Image(systemName: model.isGaining ? "arrow.up.right" : "arrow.down.right")
                }
                .foregroundStyle(model.isGaining ? .green : .red)
                .labelStyle(.titleAndIcon)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .combine)
    }
}
