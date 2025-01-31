//
//  City.swift
//  WeatherApp
//
//  Created by Hai Le Thanh on 4/15/20.
//  Copyright © 2020 Hai Le. All rights reserved.
//

import Foundation
import CoreData


@objc (City)
class City: NSManagedObject, Decodable {
    @NSManaged var id: String
    @NSManaged var name: String
    @NSManaged var state: String
    @NSManaged var country: String
    @NSManaged var latitude: Double
    @NSManaged var longitude: Double
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case state
        case country
        case coord
    }
    
    private enum CoordinateCodingKeys: String, CodingKey {
        case lon
        case lat
    }
    
    convenience init?(id: String, name: String, country: String, context: NSManagedObjectContext, saveToDB: Bool) {
        guard let entity = NSEntityDescription.entity(forEntityName: City.entityName, in: context) else {
            return nil
        }
        self.init(entity: entity, insertInto: saveToDB ? context : nil)
        self.id = id
        self.name = name
        self.country = country
    }
    
    required convenience init(from decoder: Decoder) throws {
        guard let contextKey = CodingUserInfoKey.context,
            let context = decoder.userInfo[contextKey] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: City.entityName, in: context)
            else {
                throw ManagedObjectError.noContextError
        }
        
        self.init(entity: entity, insertInto: context)
        
        do {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            self.id = String(try values.decode(Int.self, forKey: .id))
            self.name = try values.decode(String.self, forKey: .name)
            self.state = try values.decode(String.self, forKey: .state)
            self.country = try values.decode(String.self, forKey: .country)
            
            let coord = try? values.nestedContainer(keyedBy: CoordinateCodingKeys.self, forKey: .coord)
            if let coord = coord {
                self.latitude = try coord.decode(Double.self, forKey: .lat)
                self.longitude = try coord.decode(Double.self, forKey: .lon)
            }
        } catch {
            print(error)
            throw ManagedObjectError.decodeFail
        }
        
    }
}
