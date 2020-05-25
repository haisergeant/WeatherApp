//
//  WeatherRequestOperation.swift
//  WeatherApp
//
//  Created by Hai Le Thanh on 4/14/20.
//  Copyright © 2020 Hai Le. All rights reserved.
//

import Foundation
import CoreData

class WeatherRequestOperation: JSONCoreDataRequestOperation<Weather> {
        
    init?(cityId: String,
         urlFactory: URLFactory,
         urlSession: URLSession = .shared,
         parentContext: NSManagedObjectContext) {
        guard let url = urlFactory.weatherURL(cityId: cityId) else { return nil }        
        super.init(url: url, urlSession: urlSession, parentContext: parentContext)
    }
}
