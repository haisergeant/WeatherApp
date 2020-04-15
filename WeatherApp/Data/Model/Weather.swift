//
//  Weather.swift
//  WeatherApp
//
//  Created by Hai Le on 7/4/20.
//  Copyright © 2020 Hai Le. All rights reserved.
//

import Foundation
import CoreData

@objc (Weather)
class Weather: NSManagedObject, Decodable {
    @NSManaged var id: Int32
    @NSManaged var name: String
    @NSManaged var order: Int16
    
    @NSManaged var date: Date
    
    @NSManaged var latitude: Double
    @NSManaged var longitude: Double
    
    @NSManaged var weatherId: Int32
    @NSManaged var weatherMain: String
    @NSManaged var weatherDescription: String
    @NSManaged var weatherIcon: String
    
    @NSManaged var temp: Double
    @NSManaged var feelsLike: Double
    @NSManaged var tempMin: Double
    @NSManaged var tempMax: Double
    @NSManaged var pressure: Double
    @NSManaged var humidity: Double
        
    @NSManaged var visibility: Double
    @NSManaged var windSpeed: Double
    @NSManaged var windDegree: Double
    
    @NSManaged var country: String
    @NSManaged var sunRise: Double
    @NSManaged var sunSet: Double
    
    @NSManaged var timezone: Double
    
    private enum CodingKeys: String, CodingKey {
        case name
        case id
        case coord
        case weather
        case main
        case visibility
        case wind
        case sys
    }
    
    private enum CoordinateCodingKeys: String, CodingKey {
        case lon
        case lat
    }
    
    private enum WeatherCodingKeys: String, CodingKey {
        case id
        case main
        case description
        case icon
    }
    
    private enum TempCodingKeys: String, CodingKey {
        case temp
        case feels_like
        case temp_min
        case temp_max
        case pressure
        case humidity
    }
    
    private enum WindKeys: String, CodingKey {
        case speed
        case deg
    }
    
    private enum SysKeys: String, CodingKey {
        case country
        case sunrise
        case sunset
    }
    
    required convenience init(from decoder: Decoder) throws {
        guard let contextKey = CodingUserInfoKey.context,
            let context = decoder.userInfo[contextKey] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: Weather.entityName, in: context)
        else {
            throw ManagedObjectError.noContextError
        }
        
        self.init(entity: entity, insertInto: context)
        
        do {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            self.name = try values.decode(String.self, forKey: .name)
            self.id = try values.decode(Int32.self, forKey: .id)
            
            let coord = try? values.nestedContainer(keyedBy: CoordinateCodingKeys.self, forKey: .coord)
            if let coord = coord {
                self.latitude = try coord.decode(Double.self, forKey: .lat)
                self.longitude = try coord.decode(Double.self, forKey: .lon)
            }
            
            let weather = try? values.nestedContainer(keyedBy: WeatherCodingKeys.self, forKey: .weather)
            if let weather = weather {
                self.weatherId = try weather.decode(Int32.self, forKey: .id)
                self.weatherMain = try weather.decode(String.self, forKey: .main)
                self.weatherDescription = try weather.decode(String.self, forKey: .description)
                self.weatherIcon = try weather.decode(String.self, forKey: .icon)
            }
            
            let main = try? values.nestedContainer(keyedBy: TempCodingKeys.self, forKey: .main)
            if let main = main {
                self.temp = try main.decode(Double.self, forKey: .temp)
                self.feelsLike = try main.decode(Double.self, forKey: .feels_like)
                self.tempMin = try main.decode(Double.self, forKey: .temp_min)
                self.tempMax = try main.decode(Double.self, forKey: .temp_max)
                self.pressure = try main.decode(Double.self, forKey: .pressure)
                self.humidity = try main.decode(Double.self, forKey: .humidity)
            }
            
            self.visibility = (try? values.decode(Double.self, forKey: .visibility)) ?? 0
            
            let wind = try? values.nestedContainer(keyedBy: WindKeys.self, forKey: .wind)
            if let wind = wind {
                self.windSpeed = try wind.decode(Double.self, forKey: .speed)
                self.windDegree = try wind.decode(Double.self, forKey: .deg)
            }
            
            let sys = try? values.nestedContainer(keyedBy: SysKeys.self, forKey: .sys)
            if let sys = sys {
                self.country = try sys.decode(String.self, forKey: .country)
                self.sunRise = try sys.decode(Double.self, forKey: .sunrise)
                self.sunSet = try sys.decode(Double.self, forKey: .sunset)
            }
        } catch {
            throw ManagedObjectError.decodeFail
        }
    }
}

