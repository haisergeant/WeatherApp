//
//  WeatherDetailViewController.swift
//
//  Created by Hai Le Thanh.
//  Copyright © 2020 Hai Le. All rights reserved.
//
	

import UIKit

protocol WeatherDetailViewProtocol: class {
    func configure(with viewModel: WeatherDetailViewModelProtocol)
}

class WeatherDetailViewController: UIViewController {
    private var viewModel: WeatherDetailViewModelProtocol?
    
    @IBOutlet private weak var topContainer: UIView!
    @IBOutlet private weak var cityLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var temperatureLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    
    func setup(with viewModel: WeatherDetailViewModelProtocol) {
        self.viewModel = viewModel
        viewModel.bind(to: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.viewWillAppear()
    }
    
    private func configureSubviews() {
        tableView.register(TitleDescriptionTableViewCell.self)
        tableView.separatorStyle = .none
        tableView.alpha = 0
        topContainer.alpha = 0
        
        cityLabel.transform = .init(scaleX: 0, y: 0)
        descriptionLabel.transform = .init(scaleX: 0, y: 0)
        temperatureLabel.transform = .init(scaleX: 0, y: 0)
    }
    
    private func animateSubviews() {
        topContainer.animate([
            .changeAlpha(duration: 0.3, alpha: 1.0)
        ])
        tableView.animate([
            .changeAlpha(duration: 0.5, delay: 1, alpha: 1.0)
        ])
        
        cityLabel.animate([
            .scale(duration: 0.5, delay: 0.4, scale: 1.0)
        ])
        descriptionLabel.animate([
            .scale(duration: 0.5, delay: 0.5, scale: 1.0)
        ])
        temperatureLabel.animate([
            .scale(duration: 0.5, delay: 0.7, scale: 1.0)
        ])
    }
}

extension WeatherDetailViewController: WeatherDetailViewProtocol {
    func configure(with viewModel: WeatherDetailViewModelProtocol) {
        topContainer.backgroundColor = .appLightPurple
        
        cityLabel.text = viewModel.city
        cityLabel.textColor = .appDarkPurple
        
        descriptionLabel.text = viewModel.weatherDescription
        descriptionLabel.textColor = .appDarkOrange
        
        temperatureLabel.text = viewModel.temperature
        temperatureLabel.textColor = .appDarkGreen
        
        tableView.reloadData()
        
        animateSubviews()
    }
}

extension WeatherDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRows ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel else { return UITableViewCell() }
        let cell: TitleDescriptionTableViewCell = tableView.dequeueReuseableCell(indexPath: indexPath)
        cell.configure(with: viewModel.cellViewModel(at: indexPath.row))
        return cell
    }
}
