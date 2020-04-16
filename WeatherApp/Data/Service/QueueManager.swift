//
//  QueueManager.swift
//  WeatherApp
//
//  Created by Hai Le on 8/4/20.
//  Copyright © 2020 Hai Le. All rights reserved.
//

import Foundation

class QueueManager {
    static let shared = QueueManager()
    
    private let queue = OperationQueue()
    
    private init() {
        queue.maxConcurrentOperationCount = 10
    }
    
    func queue(_ operation: Operation) {
        print("======================================================")
        print("executing: \(queue.operations.filter { $0.isExecuting }.count)")
        print("cancel: \(queue.operations.filter { $0.isCancelled }.count)")
        print("ready: \(queue.operations.filter { $0.isReady }.count)")
        print("finish: \(queue.operations.filter { $0.isFinished }.count)")
        queue.addOperation(operation)
    }
}
