//
//  StockItemDetails.swift
//  StockMonitor
//
//  Created by Yury Ramazanov on 13.05.2026.
//

public struct StockItemDetails: Equatable {
    public let symbol: String
    public let previousClose: Double?
    public let open: Double?
    public let dayLow: Double?
    public let dayHigh: Double?
    public let marketCap: Int64?
    public let volume: Int64?
    public let averageVolume: Int64?
    public let fiftyTwoWeekLow: Double?
    public let fiftyTwoWeekHigh: Double?
    public let fiftyDayAverage: Double?
    public let twoHundredDayAverage: Double?
    public let beta: Double?
    public let trailingPE: Double?
    public let forwardPE: Double?
    public let dividendRate: Double?
    public let dividendYield: Double?
    public let currency: String?
    
    public init(symbol: String,
                previousClose: Double?,
                open: Double?,
                dayLow: Double?,
                dayHigh: Double?,
                marketCap: Int64?,
                volume: Int64?,
                averageVolume: Int64?,
                fiftyTwoWeekLow: Double?,
                fiftyTwoWeekHigh: Double?,
                fiftyDayAverage: Double?,
                twoHundredDayAverage: Double?,
                beta: Double?,
                trailingPE: Double?,
                forwardPE: Double?,
                dividendRate: Double?,
                dividendYield: Double?,
                currency: String?) {
        self.symbol = symbol
        self.previousClose = previousClose
        self.open = open
        self.dayLow = dayLow
        self.dayHigh = dayHigh
        self.marketCap = marketCap
        self.volume = volume
        self.averageVolume = averageVolume
        self.fiftyTwoWeekLow = fiftyTwoWeekLow
        self.fiftyTwoWeekHigh = fiftyTwoWeekHigh
        self.fiftyDayAverage = fiftyDayAverage
        self.twoHundredDayAverage = twoHundredDayAverage
        self.beta = beta
        self.trailingPE = trailingPE
        self.forwardPE = forwardPE
        self.dividendRate = dividendRate
        self.dividendYield = dividendYield
        self.currency = currency
    }
}
