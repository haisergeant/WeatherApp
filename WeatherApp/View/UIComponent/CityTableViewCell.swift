//
//  CityTableViewCell.swift
//  WeatherApp
//
//  Created by Hai Le on 8/4/20.
//  Copyright © 2020 Hai Le. All rights reserved.
//

import UIKit

struct CityCellViewModel: BaseViewModel {
    let city: String
    let country: Observable<String?>
    let temperature: Observable<String?>
    
    let color: Color
    
    struct Color {
        let cityColor: UIColor
        let countryColor: UIColor
        let tempColor: UIColor
        let backgroundColor: UIColor
    }
}

class CityTableViewCell: UITableViewCell, Reuseable, ViewConfigurable {
    
    @IBOutlet private weak var cityLabel: UILabel!
    @IBOutlet private weak var countryLabel: UILabel!
    @IBOutlet private weak var temperatureLabel: UILabel!
    @IBOutlet private weak var container: UIView!
    
    private var viewModel: CityCellViewModel?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel?.temperature.valueChanged = nil
    }
    
    func configure(with viewModel: BaseViewModel) {
        guard let viewModel = viewModel as? CityCellViewModel else { return }
        
        self.viewModel = viewModel
        cityLabel.text = viewModel.city
        cityLabel.textColor = viewModel.color.cityColor
        
        countryLabel.text = viewModel.country.value
        countryLabel.textColor = viewModel.color.countryColor
        
        temperatureLabel.text = viewModel.temperature.value
        temperatureLabel.textColor = viewModel.color.tempColor
        
        container.backgroundColor = viewModel.color.backgroundColor
        
        viewModel.temperature.valueChanged = { value in
            self.temperatureLabel.text = viewModel.temperature.value
        }
        
        viewModel.country.valueChanged = { value in
            self.countryLabel.text = viewModel.country.value
        }
        
    }
}
