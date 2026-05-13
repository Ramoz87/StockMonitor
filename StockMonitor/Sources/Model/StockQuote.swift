//
//  StockQuote.swift
//  StockMonitor
//
//  Created by Yury Ramazanov on 13.05.2026.
//

struct StockQuoteResponse: Decodable {
    let quoteResponse: QuoteResponse
}

struct QuoteResponse: Decodable {
    let result: [Quote]
    let error: String?
}

struct Quote: Decodable {
    let symbol: String?
    let quoteSummary: QuoteSummary?
    
}

struct QuoteSummary: Decodable {
    let summaryDetail: QuoteSummaryDetail?
}

struct QuoteSummaryDetail: Decodable {
    let maxAge: Int?
    let priceHint: Int?

    let previousClose: Double?
    let open: Double?
    let dayLow: Double?
    let dayHigh: Double?

    let regularMarketPreviousClose: Double?
    let regularMarketOpen: Double?
    let regularMarketDayLow: Double?
    let regularMarketDayHigh: Double?

    let dividendRate: Double?
    let dividendYield: Double?
    let exDividendDate: Int?
    let payoutRatio: Double?
    let fiveYearAvgDividendYield: Double?

    let beta: Double?
    let trailingPE: Double?
    let forwardPE: Double?

    let volume: Int64?
    let regularMarketVolume: Int64?
    let averageVolume: Int64?
    let averageVolume10days: Int64?
    let averageDailyVolume10Day: Int64?

    let bid: Double?
    let ask: Double?
    let bidSize: Int?
    let askSize: Int?

    let marketCap: Int64?
    let nonDilutedMarketCap: Int64?

    let fiftyTwoWeekLow: Double?
    let fiftyTwoWeekHigh: Double?
    let allTimeHigh: Double?
    let allTimeLow: Double?

    let priceToSalesTrailing12Months: Double?
    let fiftyDayAverage: Double?
    let twoHundredDayAverage: Double?

    let trailingAnnualDividendRate: Double?
    let trailingAnnualDividendYield: Double?

    let currency: String?
    let fromCurrency: String?
    let toCurrency: String?
    let lastMarket: String?
    let coinMarketCapLink: String?
    let algorithm: String?

    let tradeable: Bool?
}

