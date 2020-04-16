//
//  CitySearchViewModel.swift
//  WeatherApp
//
//  Created by Hai Le Thanh on 4/15/20.
//  Copyright © 2020 Hai Le. All rights reserved.
//

import Foundation

protocol CitySearchViewModelProtocol {
    func bind(to view: CitySearchViewProtocol)
    func searchCity(_ keyword: String)
    func toggleItem(at index: Int)
    func saveSelection()
}


class CitySearchViewModel {
    private weak var view: CitySearchViewProtocol?
    private let dataManager: DataManagerProtocol
    
    private var originalAddedIds: [String]
    private var selectedCities: [City]
    private var searchResults: [City] = []
    private var viewModels: [SearchCityCellViewModel] = []
    
    init(dataManager: DataManagerProtocol) {
        self.dataManager = dataManager
        
        let weathers: [Weather] = dataManager.fetchDataFromDB(fetchLimit: 0,
                                                              predicate: nil,
                                                              sortDescriptors: nil)
        
        self.originalAddedIds = weathers.compactMap { $0.id }
        self.selectedCities = weathers.compactMap { City(id: $0.id,
                                                          name: $0.name,
                                                          country: $0.country,
                                                          context: dataManager.context,
                                                          saveToDB: false) }
    }
}

extension CitySearchViewModel: CitySearchViewModelProtocol {
    func bind(to view: CitySearchViewProtocol) {
        self.view = view
    }
    
    func searchCity(_ keyword: String) {
        // TODO: debounce
        guard !keyword.isEmpty, keyword.count > 3 else {
            constructViewModels(with: [])
            return
        }
        let predicate = NSPredicate(format: "name contains[c] '\(keyword)'")
        let cities: [City] = dataManager.fetchDataFromDB(fetchLimit: 10,
                                                         predicate: predicate,
                                                         sortDescriptors: nil)
        
        constructViewModels(with: cities)
    }
    
    func toggleItem(at index: Int) {
        let viewModel = viewModels[index]
        viewModel.isAdded.value.toggle()
        let city = searchResults[index]
        if viewModel.isAdded.value {
            selectedCities.append(city)
        } else {
            selectedCities = selectedCities.filter { $0.id != city.id }
        }
    }
    
    func saveSelection() {
        let newAddedCities = selectedCities.filter { !originalAddedIds.contains($0.id) }
        
        removeSavedWeathersIfNeeded()
        let weatherRecords = newAddedCities.compactMap {
            Weather(id: $0.id, name: $0.name, country: $0.country,
                    context: dataManager.context,
                    saveToDB: true)
        }
        
        // set up order
        for (index, weather) in weatherRecords.enumerated() {
            weather.order = Int16(index) + Int16(originalAddedIds.count)
        }
        do {
            try dataManager.saveIfNeeded()
        } catch {
            print(error)
        }
    }
    
    private func removeSavedWeathersIfNeeded() {
        let addedCityIds = selectedCities.compactMap { $0.id }
        var removedIds = [String]()
        for item in originalAddedIds {
            if !addedCityIds.contains(item) {
                removedIds.append(item)
            }
        }
        
        if !removedIds.isEmpty {
            let predicate = NSPredicate(format: "id in %@", removedIds)            
            dataManager.clearDataFromDB(type: Weather.self, predicate: predicate)
        }
    }
    
    private func constructViewModels(with results: [City]) {
        searchResults.removeAll()
        searchResults.append(contentsOf: results)
        viewModels.removeAll()
        let addedIds = selectedCities.compactMap { $0.id }
        let cellModels: [SearchCityCellViewModel] = searchResults.compactMap { city in
            let alreadyAdded = addedIds.contains(city.id)
            return SearchCityCellViewModel(cityName: city.name + ", " + city.country,
                                           isAdded: Observable<Bool>(alreadyAdded)) }
        viewModels.append(contentsOf: cellModels)
                
        view?.configure(with: viewModels)
    }
}

