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
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.viewWillAppear()
    }
    
    private func configureTableView() {
        tableView.register(TitleDescriptionTableViewCell.self)
        tableView.separatorStyle = .none
    }
}

extension WeatherDetailViewController: WeatherDetailViewProtocol {
    func configure(with viewModel: WeatherDetailViewModelProtocol) {
        cityLabel.text = viewModel.city
        descriptionLabel.text = viewModel.weatherDescription
        temperatureLabel.text = viewModel.temperature
        
        tableView.reloadData()
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
