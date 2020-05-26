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
    
    func weather(at index: Int) -> Weather
}

class WeatherListViewModel {
    private weak var view: WeatherListViewProtocol?
    private let dataManager: DataManagerProtocol
    private let weatherManager: WeatherManager
    
    private var cities: [Weather] = []
    private(set) var viewModels: [CityCellViewModel] = []
    private lazy var colors: [CityCellViewModel.Color] = [
        CityCellViewModel.Color(cityColor: .appDarkPurple,
                                countryColor: .appDarkRed,
                                tempColor: .appDarkRed,
                                backgroundColor: .appLightPurple),
        CityCellViewModel.Color(cityColor: .appDarkPurple,
                                countryColor: .appDarkGreen,
                                tempColor: .appDarkGreen,
                                backgroundColor: .appLightPurple),
        CityCellViewModel.Color(cityColor: .appDarkPurple,
                                countryColor: .appDarkOrange,
                                tempColor: .appDarkOrange,
                                backgroundColor: .appLightPurple),
        CityCellViewModel.Color(cityColor: .appDarkPurple,
                                countryColor: .appDarkPurple,
                                tempColor: .appDarkPurple,
                                backgroundColor: .appLightPurple),
    ]
    
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
        self.viewModels.removeAll()
        for (index, city) in cities.enumerated() {
            let color = self.colors[index % self.colors.count]
            viewModels.append(CityCellViewModel(city: city.name,
                                                country: Observable<String?>(city.country),
                                                temperature: Observable<ValueState<String>>(city.temp == 0 ? .loading : .value(value: city.temp.degree)),
                                                color: color))
        }
                
        view?.configure(with: viewModels)
    }
    
    func requestInfo(at index: Int) {
        let city = cities[index]
        let viewModel = viewModels[index]
        
        // TODO: Debounce?
        weatherManager.setupTimer(cityId: String(city.id)) { result in
            switch result {
            case .success(_):
                try? self.dataManager.saveIfNeeded()
                viewModel.country.value = city.country
                viewModel.temperature.value = ValueState.value(value: city.temp.degree)
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
    
    func weather(at index: Int) -> Weather {
        return cities[index]
    }
}
