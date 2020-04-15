//
//  NSManagedObject+Extension.swift
//  WeatherApp
//
//  Created by Hai Le on 7/4/20.
//  Copyright © 2020 Hai Le. All rights reserved.
//

import CoreData

extension NSManagedObject {
    static var entityName: String {
        String(describing: self)
    }
}

enum ManagedObjectError: Error {
    case noContextError
    case decodeFail
}

extension CodingUserInfoKey {
    static let context = CodingUserInfoKey(rawValue: "context")
}
