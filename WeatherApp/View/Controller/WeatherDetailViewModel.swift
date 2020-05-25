//
//  WeatherDetailViewModel.swift
//
//  Created by Hai Le Thanh.
//  Copyright © 2020 Hai Le. All rights reserved.
//
	

import Foundation

protocol WeatherDetailViewModelProtocol {
    func bind(to view: WeatherDetailViewProtocol)
    func viewWillAppear()
    
    var city: String { get }
    var weatherDescription: String { get }
    var temperature: String { get }
    
    var numberOfRows: Int { get }
    func cellViewModel(at index: Int) -> BaseViewModel
}

class WeatherDetailViewModel {
    private weak var view: WeatherDetailViewProtocol?
    private let weather: Weather
    private let viewModels: [TitleDescriptionCellViewModel]
    
    init(weather: Weather) {
        self.weather = weather
        
        self.viewModels = [
            TitleDescriptionCellViewModel(title: "Min temperature", description: weather.tempMin.degree),
            TitleDescriptionCellViewModel(title: "Max temperature", description: weather.tempMax.degree),
            TitleDescriptionCellViewModel(title: "Humidity", description: String(format: "%.0f%%", weather.humidity))
        ]
    }
}

extension WeatherDetailViewModel: WeatherDetailViewModelProtocol {
    func bind(to view: WeatherDetailViewProtocol) {
        self.view = view
    }
    
    func viewWillAppear() {
        view?.configure(with: self)
    }
    
    var city: String {
        return weather.name
    }
    
    var weatherDescription: String {
        return weather.weatherDescription
    }
    
    var temperature: String {
        return weather.temp.degree
    }
    
    var numberOfRows: Int {
        return 3
    }
    
    func cellViewModel(at index: Int) -> BaseViewModel {
        return viewModels[index]
    }
}
