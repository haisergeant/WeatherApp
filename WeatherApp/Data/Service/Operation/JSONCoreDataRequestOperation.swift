//
//  JSONCoreDataRequestOperation.swift
//  WeatherApp
//
//  Created by Hai Le Thanh on 4/21/20.
//  Copyright © 2020 Hai Le. All rights reserved.
//

import Foundation
import CoreData

class JSONCoreDataRequestOperation<T: Decodable>: BaseOperation<T> where T: NSManagedObject {
        
    private let urlSession: URLSession
    private let url: URL
    private var dataTask: URLSessionDataTask?
    private let parentContext: NSManagedObjectContext
    
    init(url: URL, urlSession: URLSession = .shared, parentContext: NSManagedObjectContext) {
        self.url = url
        self.urlSession = urlSession
        self.parentContext = parentContext
    }
    
    override func main() {
        dataTask = urlSession.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self else { return }
            do {
                if let error = error {
                    self.complete(result: .failure(error))
                } else if let data = data {
                    let decoder = JSONDecoder()
                    let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
                    context.parent = self.parentContext
                    if let key = CodingUserInfoKey.context {
                        decoder.userInfo[key] = context
                    }
                    
                    let result = try decoder.decode(T.self, from: data)
                    if context.hasChanges {
                        do {
                            try context.save()
                        } catch {
                            self.complete(result: .failure(CoreDataError.saveContextError))
                        }
                    }
                    
                    self.complete(result: .success(result))
                }
            } catch {
                self.complete(result: .failure(APIError.jsonFormatError))
            }
        }
        dataTask?.resume()
    }
    
    override func cancel() {
        dataTask?.cancel()
        super.cancel()
    }
}
