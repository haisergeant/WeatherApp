//
//  WeatherManager.swift
//  WeatherApp
//
//  Created by Hai Le Thanh on 4/14/20.
//  Copyright © 2020 Hai Le. All rights reserved.
//

import Foundation
import CoreData

class WeatherManager {
    private let queueManager: QueueManager
    private let urlFactory: URLFactory
    private let parentContext: NSManagedObjectContext
    private let urlSession: URLSession
    
    typealias OperationCompletionHandler = (Result<Weather, Error>) -> Void
    private var timerDict: [String: Timer] = [:]
    private var handlerDict: [String: OperationCompletionHandler] = [:]
    private var operationDict: [String: Operation] = [:]
    
    init(queueManager: QueueManager = QueueManager.shared,
         urlFactory: URLFactory = URLFactory(),
         urlSession: URLSession = .shared,
         parentContext: NSManagedObjectContext = CoreDataManager.shared.context) {
        self.queueManager = queueManager
        self.urlFactory = urlFactory
        self.parentContext = parentContext
        self.urlSession = urlSession
    }
    
    func setupTimer(cityId: String,
                    completion: ((Result<Weather, Error>) -> Void)?) {
        let timer: Timer
        if !timerDict.keys.contains(cityId) {
            let dict: [String : Any] = ["cityId": cityId]
                        
            timer = Timer.scheduledTimer(timeInterval: Constants.timeIntervalRequest,
                                         target: self, selector: #selector(configureTimer(timer:)), userInfo: dict, repeats: true)
            timerDict[cityId] = timer
            handlerDict[cityId] = completion
            timer.fire()
        }
    }
    
    func disableTimer(cityId: String) {
        if timerDict.keys.contains(cityId) {
            let timer = timerDict[cityId]
            timer?.invalidate()
            timerDict.removeValue(forKey: cityId)
            handlerDict.removeValue(forKey: cityId)
            let operation = operationDict[cityId]
            operation?.cancel()
            operationDict.removeValue(forKey: cityId)
        }
    }
    
    @objc private func configureTimer(timer: Timer) {
        guard let userInfo = timer.userInfo as? [String: String],
            let cityId = userInfo["cityId"],
            let completionHandler = handlerDict[cityId],
            let operation = WeatherRequestOperation(cityId: cityId,
                                                    urlFactory: urlFactory,
                                                    urlSession: urlSession,
                                                    parentContext: parentContext) else { return }
        operation.completionHandler = { result in
            self.operationDict.removeValue(forKey: cityId)
            DispatchQueue.main.async {
                completionHandler(result)
            }            
        }
        operationDict[cityId] = operation
        queueManager.queue(operation)
    }
}
