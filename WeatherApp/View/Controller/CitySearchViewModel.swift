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
}


class CitySearchViewModel {
    private weak var view: CitySearchViewProtocol?
    private let dataManager: DataManagerProtocol
    
    private var selectedCityIds: [City] = []
    private var searchResults: [City] = []
    private var viewModels: [SearchCityCellViewModel] = []
    
    init(dataManager: DataManagerProtocol) {
        self.dataManager = dataManager
        
        let weathers: [Weather] = dataManager.fetchDataFromDB(predicate: nil,
                                                              sortDescriptors: nil)
        self.selectedCityIds = weathers.compactMap { City(id: $0.id,
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
        guard !keyword.isEmpty else {
            constructViewModels(with: [])
            return
        }
        let predicate = NSPredicate(format: "name contains[c] '\(keyword)'")
        let cities: [City] = dataManager.fetchDataFromDB(predicate: predicate, sortDescriptors: nil)
        
        constructViewModels(with: cities)
    }
    
    private func constructViewModels(with results: [City]) {
        searchResults.removeAll()
        searchResults.append(contentsOf: results)
        viewModels.removeAll()
        let addedIds = selectedCityIds.compactMap { $0.id }
        let cellModels: [SearchCityCellViewModel] = searchResults.compactMap { city in
            let alreadyAdded = addedIds.contains(city.id)
            return SearchCityCellViewModel(cityName: city.name,
                                           isAdded: Observable<Bool>(alreadyAdded)) }
        viewModels.append(contentsOf: cellModels)
        
        
        view?.configure(with: viewModels)
    }
}

