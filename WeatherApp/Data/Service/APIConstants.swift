//
//  APIConstants.swift
//  WeatherApp
//
//  Created by Hai Le on 7/4/20.
//  Copyright © 2020 Hai Le. All rights reserved.
//

import Foundation

struct APIConstants {
    static let WEATHER_APP_ID = "bc79cc6d9992df5e82a9da3abec80631"
    static let WEATHER_CITY_REQUEST = "https://api.openweathermap.org/data/2.5/weather?id=%@&appid=%@&units=metric"
}

enum APIError: Error {
    case invalidAPIError
    case jsonFormatError
}
