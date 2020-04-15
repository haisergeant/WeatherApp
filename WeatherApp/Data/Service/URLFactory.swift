//
//  URLFactory.swift
//  WeatherApp
//
//  Created by Hai Le Thanh on 4/14/20.
//  Copyright © 2020 Hai Le. All rights reserved.
//

import Foundation

class URLFactory {
    func weatherURL(cityId: String) -> URL? {
        let urlString = String(format: APIConstants.WEATHER_CITY_REQUEST, cityId, APIConstants.WEATHER_APP_ID)
        return URL(string: urlString)
    }
}
