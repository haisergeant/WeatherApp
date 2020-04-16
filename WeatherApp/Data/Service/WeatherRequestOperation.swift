//
//  WeatherRequestOperation.swift
//  WeatherApp
//
//  Created by Hai Le Thanh on 4/14/20.
//  Copyright © 2020 Hai Le. All rights reserved.
//

import Foundation
import CoreData

class WeatherRequestOperation: BaseOperation<Weather> {
    private let cityId: String
    private let jsonDecoder: JSONDecoder
    private let urlSession: URLSession
    private let urlFactory: URLFactory
    private var dataTask: URLSessionDataTask?
    
    init(cityId: String, jsonDecoder: JSONDecoder, urlSession: URLSession, urlFactory: URLFactory) {
        self.cityId = cityId
        self.jsonDecoder = jsonDecoder
        self.urlSession = urlSession
        self.urlFactory = urlFactory
    }
    
    override func main() {
        guard let url = urlFactory.weatherURL(cityId: cityId) else {
            complete(result: .failure(APIError.invalidAPIError))
            return
        }
        
        dataTask = urlSession.dataTask(with: url) { (data, response, error) in
            do {
                if let error = error {
                    self.complete(result: .failure(error))
                } else if let data = data {
                    let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
                    context.parent = CoreDataManager.shared.context
                    let decoder = JSONDecoder()
                    if let key = CodingUserInfoKey.context {
                        decoder.userInfo[key] = context
                    }
                    
                    let result = try decoder.decode(Weather.self, from: data)
                    
                    context.perform {
                        try? context.save()
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
