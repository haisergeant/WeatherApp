//
//  AppDelegate.swift
//  WeatherApp
//
//  Created by Hai Le on 7/4/20.
//  Copyright © 2020 Hai Le. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private var coordinator: WeatherCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        CoreDataManager.shared.setup()
        coordinator = WeatherCoordinator()
        window?.rootViewController = coordinator?.initialController
        
        return true
    }
}

