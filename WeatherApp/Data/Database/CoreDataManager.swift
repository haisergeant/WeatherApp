//
//  CoreDataManager.swift
//  WeatherApp
//
//  Created by Hai Le on 7/4/20.
//  Copyright © 2020 Hai Le. All rights reserved.
//

import CoreData

private struct Constant {
    static let firstLoad = "FIRST_LOAD"
}

protocol DataManagerProtocol {
    func saveIfNeeded() throws
    func fetchDataFromDB<T: NSManagedObject>(fetchLimit: Int,
                                             predicate: NSPredicate?,
                                             sortDescriptors: [NSSortDescriptor]?) -> [T]
    func clearDataFromDB<T>(type: T.Type) where T: NSManagedObject
    func save<T: NSManagedObject>(_ object: T) throws
    var context: NSManagedObjectContext { get }
}

class CoreDataManager {
    static let shared = CoreDataManager()
    private var storeType: String?
    
    private(set) lazy var jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        if let key = CodingUserInfoKey.context {
            decoder.userInfo[key] = context
        }
        return decoder
    }()
    
    private(set) lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "WeatherApp")
        if let description = container.persistentStoreDescriptions.first, let storeType = storeType {
            description.type = storeType
        }
        
        return container
    }()
    
    func setup(storeType: String = NSSQLiteStoreType, completion: (() -> Void)? = nil) {
        self.storeType = storeType
        loadPersistentStore {
            completion?()
        }
    }
    
    private func loadPersistentStore(completion: @escaping (() -> Void)) {
        persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
            guard error == nil else {
                fatalError("Cannot load persistent store with error")
            }
            self.context.automaticallyMergesChangesFromParent = true
            self.context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            completion()
            
            self.insertDefaultDataIfNeed()
        })
    }
    
    // TODO: not generic?
    private func insertDefaultDataIfNeed() {
        let userDefaults = UserDefaults.standard
        if userDefaults.object(forKey: Constant.firstLoad) == nil {
            
            
            insertJSONDataIfNeeded(Weather.self, jsonDecoder: jsonDecoder, fileName: "default-countries") { list in
                for (i, item) in list.enumerated() {
                    item.order = Int16(i)
                }
                try? self.saveIfNeeded()
            }
            
            persistentContainer.performBackgroundTask { (context) in
                let decoder = JSONDecoder()
                if let key = CodingUserInfoKey.context {
                    decoder.userInfo[key] = context
                }
                context.automaticallyMergesChangesFromParent = true
                self.insertJSONDataIfNeeded(City.self, jsonDecoder: decoder, fileName: "city-list") { list in
                    userDefaults.set(Constant.firstLoad, forKey: Constant.firstLoad)
                    try? context.save()
                }
            }
        }
    }
    
    private func insertJSONDataIfNeeded<T: NSManagedObject>(_ type: T.Type,
                                                            jsonDecoder: JSONDecoder,
                                                            fileName: String,
                                                            fileType: String = "json",
                                                            modification: (([T]) -> ())? = nil) where T: Decodable {
        let currentData: [T] = fetchDataFromDB()
        guard currentData.isEmpty,
            let jsonPath = Bundle.main.path(forResource: fileName,
                                            ofType: fileType,
                                            inDirectory: nil,
                                            forLocalization: nil),
            let content = try? String(contentsOfFile: jsonPath),
            let data = content.data(using: .utf8),
            let list = (try? jsonDecoder.decode([T].self, from: data)) else { return }
        modification?(list)
    }
}

extension CoreDataManager: DataManagerProtocol {
    func saveIfNeeded() throws {
        if context.hasChanges {
            try context.save()
        }
    }
    
    func fetchDataFromDB<T: NSManagedObject>(fetchLimit: Int = 0,
                                             predicate: NSPredicate? = nil,
                                             sortDescriptors: [NSSortDescriptor]? = nil) -> [T] {
        let fetchRequest = NSFetchRequest<T>(entityName: T.entityName)
        fetchRequest.sortDescriptors = sortDescriptors
        fetchRequest.fetchLimit = fetchLimit
        fetchRequest.predicate = predicate
        do {
            let list = try context.fetch(fetchRequest)
            return list
        } catch {
            print(error)
            return []
        }
    }
    
    func clearDataFromDB<T>(type: T.Type) where T: NSManagedObject {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: T.entityName)
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(batchDeleteRequest)
        } catch {
            print(error)
        }
    }
    
    func save<T: NSManagedObject>(_ object: T) throws {
        if object.hasChanges {
            try saveIfNeeded()
        }
    }
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
}
