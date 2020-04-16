//
//  WeatherListViewModel.swift
//  WeatherApp
//
//  Created by Hai Le on 7/4/20.
//  Copyright © 2020 Hai Le. All rights reserved.
//

import Foundation

protocol WeatherListViewModelProtocol {
    func bind(to view: WeatherListViewProtocol)
    func requestInfo(at index: Int)
    func stopRequestInfo(at index: Int)
    
    func viewWillAppear()
    func viewWillDisappear()
}

class WeatherListViewModel {
    private weak var view: WeatherListViewProtocol?
    private let dataManager: DataManagerProtocol
    private let weatherManager: WeatherManager
    
    private var cities: [Weather] = []
    private(set) var viewModels: [CityCellViewModel] = []
    
    init(dataManager: DataManagerProtocol, weatherManager: WeatherManager) {
        self.dataManager = dataManager
        self.weatherManager = weatherManager
    }
    
    func bind(to view: WeatherListViewProtocol) {
        self.view = view
    }
}

extension WeatherListViewModel: WeatherListViewModelProtocol {
    private func fetchData() {
        let sortDescriptor = NSSortDescriptor(key: "order", ascending: true)
        cities = dataManager.fetchDataFromDB(fetchLimit: 0,
                                             predicate: nil,
                                             sortDescriptors: [sortDescriptor])
        
        self.viewModels = cities.compactMap { city in            
            CityCellViewModel(city: city.name,
                              country: Observable<String?>(city.country),
                              temperature: Observable<String?>(city.temp.degree))
        }
        
        view?.configure(with: viewModels)
    }
    
    func requestInfo(at index: Int) {
        let city = cities[index]
        let viewModel = viewModels[index]
        
        // TODO: Debounce?
        weatherManager.setupTimer(cityId: String(city.id)) { result in
            switch result {
            case .success(let weather):
                
                viewModel.country.value = weather.country
                viewModel.temperature.value = weather.temp.degree
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func stopRequestInfo(at index: Int) {
        guard index < cities.count else { return }
        let city = cities[index]
        
        weatherManager.disableTimer(cityId: String(city.id))
    }
    
    func viewWillAppear() {
        fetchData()
        for i in 0..<cities.count {
            requestInfo(at: i)
        }
    }
    
    func viewWillDisappear() {
        for i in 0..<cities.count {
            stopRequestInfo(at: i)
        }
    }
}
