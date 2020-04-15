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
}


class CitySearchViewModel {
    private weak var view: CitySearchViewProtocol?
    
    
    
}

extension CitySearchViewModel: CitySearchViewModelProtocol {
    func bind(to view: CitySearchViewProtocol) {
        self.view = view
    }
}

