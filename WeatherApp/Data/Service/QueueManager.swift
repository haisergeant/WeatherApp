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
        queue.addOperation(operation)
    }
}
