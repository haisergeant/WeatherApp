//
//  CoreDataManagerTests.swift
//
//  Created by Hai Le Thanh.
//  Copyright © 2020 Hai Le. All rights reserved.
//
	

import XCTest
@testable import WeatherApp

class CoreDataManagerTests: XCTestCase {
    var manager: CoreDataManager!
    
    override func setUp() {
        super.setUp()
        self.manager = CoreDataManager.shared
    }
    
    func testLoadedAndHaveDefaultData() {
        XCTAssert(manager.persistentContainer.name == "WeatherApp", "Should have the name of WeatherApp")
        
        let cities: [City] = manager.fetchDataFromDB()
        XCTAssert(cities.count > 0, "Have default data")
        
        let countries: [Weather] = manager.fetchDataFromDB()
        XCTAssert(countries.count == 3, "Have 3 default city for weather")
    }
    
    func testAddNewCityRecord() {
        let id = "Test id"
        let name = "Test name"
        let country = "Test country"
        let _ = City(id: id, name: name, country: country, context: manager.context, saveToDB: true)!
        do {
            let predicate = NSPredicate(format: "id == '\(id)'")
            try manager.saveIfNeeded()
                        
            let saveCities: [City] = manager.fetchDataFromDB(predicate: predicate)
            let first = saveCities.first!
            XCTAssertEqual(name, first.name)
            XCTAssertEqual(id, first.id)
            XCTAssertEqual(country, first.country)
        } catch {
            XCTAssertFalse(true, "Should not throw error")
        }
    }
    
    func testFetchDefaultWeather() {
        let weathers: [Weather] = manager.fetchDataFromDB()
        
        XCTAssertEqual(weathers.count, 3)
        
        var predicate = NSPredicate(format: "id == '4163971'")
        var list: [Weather] = manager.fetchDataFromDB(predicate: predicate)
        var first = list.first!
        XCTAssertEqual(list.count, 1)
        XCTAssertEqual(first.name, "Melbourne")
        
        predicate = NSPredicate(format: "id == '2147714'")
        list = manager.fetchDataFromDB(predicate: predicate)
        first = list.first!
        XCTAssertEqual(list.count, 1)
        XCTAssertEqual(first.name, "Sydney")
        
        predicate = NSPredicate(format: "id == '2174003'")
        list = manager.fetchDataFromDB(predicate: predicate)
        first = list.first!
        XCTAssertEqual(list.count, 1)
        XCTAssertEqual(first.name, "Brisbane")
    }
}
