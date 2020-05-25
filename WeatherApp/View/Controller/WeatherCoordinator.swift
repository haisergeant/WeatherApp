//
//  WeatherCoordinator.swift
//  WeatherApp
//
//  Created by Hai Le Thanh on 4/15/20.
//  Copyright © 2020 Hai Le. All rights reserved.
//

import UIKit

enum WeatherNavigation {
    case addCity
    case weatherDetail(weather: Weather)
}

protocol WeatherCoordinatorProtocol: class {
    func navigate(_ nav: WeatherNavigation)
}

class WeatherCoordinator {
    let storyboard: UIStoryboard
    private(set) var initialController: UINavigationController?
    
    init() {
        storyboard = UIStoryboard(storyboard: .weather)
        initialController = storyboard.instantiateInitialViewController() as? UINavigationController
        
        if let controller = initialController,
            let first = controller.viewControllers.first as? WeatherListViewController {
            let dataManager = CoreDataManager.shared
            let weatherManager = WeatherManager()
            
            first.setup(with: WeatherListViewModel(dataManager: dataManager,
                                                   weatherManager: weatherManager))
            first.coordinator = self
        }
        
    }
}

extension WeatherCoordinator: WeatherCoordinatorProtocol {
    func navigate(_ nav: WeatherNavigation) {
        switch nav {
        case .addCity:
            navigateToAddCity()
        case .weatherDetail(let weather):
            navigateToWeatherDetail(weather: weather)
        }
    }
    
    private func navigateToAddCity() {
        let controller: CitySearchViewController = storyboard.instantiateViewController()
        let dataManager = CoreDataManager.shared
        let viewModel = CitySearchViewModel(dataManager: dataManager)
        controller.setup(with: viewModel)
        
        let navController = UINavigationController(rootViewController: controller)
        navController.modalPresentationStyle = .fullScreen
        initialController?.present(navController, animated: true, completion: nil)
    }
    
    private func navigateToWeatherDetail(weather: Weather) {
        let controller: WeatherDetailViewController = storyboard.instantiateViewController()
        let viewModel = WeatherDetailViewModel(weather: weather)
        controller.setup(with: viewModel)
        
        initialController?.pushViewController(controller, animated: true)
    }
}


