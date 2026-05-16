# StockMonitor

StockMonitor is an iOS stock market sample app built with Swift and SwiftUI. It displays a searchable list of stocks, refreshes market data at regular intervals, and provides a detail screen with key quote information for a selected symbol.

The repository is split into two main parts:

- `StockMonitor`: a Swift package containing API, mapping, networking, and domain model code.
- `StockMarket`: the SwiftUI application target that composes the stock list, stock detail, navigation, and view models.

Market data is loaded from the Yahoo Finance API available through RapidAPI:
[Yahoo Finance API by apidojo](https://rapidapi.com/apidojo/api/yahoo-finance1/playground).

The API key used for this datasource has request limits, so responses may fail or become unavailable after the quota is reached.
