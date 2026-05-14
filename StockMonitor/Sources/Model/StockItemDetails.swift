//
//  StockItemDetails.swift
//  StockMonitor
//
//  Created by Yury Ramazanov on 13.05.2026.
//

public struct StockItemDetails: Equatable, Sendable {
    public let symbol: String
    public let previousClose: Double?
    public let open: Double?
    public let dayLow: Double?
    public let dayHigh: Double?
    public let volume: Int64?
    public let averageVolume: Int64?
    public let fiftyTwoWeekLow: Double?
    public let fiftyTwoWeekHigh: Double?
    public let fiftyDayAverage: Double?
    public let twoHundredDayAverage: Double?
    public let currency: String?
    
    public init(symbol: String,
                previousClose: Double?,
                open: Double?,
                dayLow: Double?,
                dayHigh: Double?,
                volume: Int64?,
                averageVolume: Int64?,
                fiftyTwoWeekLow: Double?,
                fiftyTwoWeekHigh: Double?,
                fiftyDayAverage: Double?,
                twoHundredDayAverage: Double?,
                currency: String?) {
        self.symbol = symbol
        self.previousClose = previousClose
        self.open = open
        self.dayLow = dayLow
        self.dayHigh = dayHigh
        self.volume = volume
        self.averageVolume = averageVolume
        self.fiftyTwoWeekLow = fiftyTwoWeekLow
        self.fiftyTwoWeekHigh = fiftyTwoWeekHigh
        self.fiftyDayAverage = fiftyDayAverage
        self.twoHundredDayAverage = twoHundredDayAverage
        self.currency = currency
    }
}
