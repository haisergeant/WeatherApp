//
//  Double+Extension.swift
//  WeatherApp
//
//  Created by Hai Le Thanh on 4/15/20.
//  Copyright © 2020 Hai Le. All rights reserved.
//

import Foundation

extension Double {
    var degree: String {
        return String(Int(self)) + "º"
    }
}
