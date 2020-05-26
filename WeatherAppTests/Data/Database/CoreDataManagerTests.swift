//
//  CoreDataManagerTests.swift
//
//  Created by Hai Le Thanh.
//  Copyright © 2020 Hai Le. All rights reserved.
//
	

import XCTest
import CoreData
@testable import WeatherApp

class CoreDataManagerTests: XCTestCase {
    var manager: CoreDataManager!
    
    override func setUp() {
        super.setUp()
        self.manager = CoreDataManager.shared
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
}
