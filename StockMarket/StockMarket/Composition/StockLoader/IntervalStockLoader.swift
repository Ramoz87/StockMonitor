//
//  AsyncStreamBroadcaster.swift
//  StockMonitor
//
//  Created by Yury Ramazanov on 15.05.2026.
//

import Foundation
import StockMonitor

final class IntervalStockLoader: StockLoader {
    private let interval: Duration
    private let service: StockService
    
    private var updateTasks: [String: Task<Void, Never>] = [:]
    private var broadcasts: [String: AsyncStreamBroadcaster<Result<[StockItem], Error>>] = [:]
       
    init(service: StockService, interval: Duration) {
        self.service = service
        self.interval = interval
    }
    
    deinit {
        finishAllStockUpdates()
    }
    
    func stockUpdates(region: String) -> AsyncStream<Result<[StockItem], Error>> {
        return broadcaster(region: region).stream
    }
    
    func startStockUpdates(region: String) {
        guard updateTasks[region] == nil else {
            return
        }
        
        let broadcaster = broadcaster(region: region)
        let task = Task { [broadcaster, service, interval] in
            while !Task.isCancelled {
                do {
                    let result = try await service.getStocks(region: region)
                    broadcaster.send(.success(result))
                } catch {
                    broadcaster.send(.failure(error))
                }
                try? await Task.sleep(for: interval)
            }
        }
        
        updateTasks[region] = task
    }
    
    func stopStockUpdates(region: String) {
        updateTasks[region]?.cancel()
        updateTasks[region] = nil
        
        broadcasts[region]?.finish()
        broadcasts[region] = nil
    }
    
    private func finishAllStockUpdates() {
        updateTasks.values.forEach { $0.cancel() }
        updateTasks.removeAll()
        
        broadcasts.values.forEach { $0.finish() }
        broadcasts.removeAll()
    }
    
    private func broadcaster(region: String) -> AsyncStreamBroadcaster<Result<[StockItem], Error>> {
        if let broadcaster = broadcasts[region] {
            return broadcaster
        }

        let broadcaster = AsyncStreamBroadcaster<Result<[StockItem], Error>>()
        broadcasts[region] = broadcaster
        return broadcaster
    }
}

final class AsyncStreamBroadcaster<Value: Sendable>: Sendable {
    typealias Stream = AsyncStream<Value>
    typealias Continuation = Stream.Continuation
    
    private var continuations: [UUID: Continuation] = [:]

    var stream: Stream {
        let id = UUID()
        return Stream { continuation in
            continuations[id] = continuation
            
            continuation.onTermination = { [weak self] _ in
                Task {
                    await self?.removeContinuation(id)
                }
            }
        }
    }
    
    func send(_ value: Value) {
        continuations.values.forEach { $0.yield(value) }
    }
    
    func finish() {
        continuations.values.forEach { $0.finish() }
        continuations.removeAll()
    }
    
    private func removeContinuation(_ id: UUID) {
        continuations[id] = nil
    }
}
