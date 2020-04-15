//
//  WeatherListViewController.swift
//  WeatherApp
//
//  Created by Hai Le on 7/4/20.
//  Copyright © 2020 Hai Le. All rights reserved.
//

import UIKit

protocol WeatherListViewProtocol: class {
    func configure(with viewModels: [CityCellViewModel])
}

class WeatherListViewController: UITableViewController {
    private var viewModel: WeatherListViewModelProtocol?
    private var viewModels = [CityCellViewModel]()
    weak var coordinator: WeatherCoordinatorProtocol?
    
    func setup(with viewModel: WeatherListViewModelProtocol) {
        self.viewModel = viewModel
        viewModel.bind(to: self)
    }
    
    private func configureNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addMoreCity))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        viewModel?.fetchData()
        configureNavBar()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CityTableViewCell = tableView.dequeueReuseableCell(indexPath: indexPath)
        cell.configure(with: viewModels[indexPath.row])
        viewModel?.requestInfo(at: indexPath.row)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewModel?.stopRequestInfo(at: indexPath.row)
    }
    
    @objc func addMoreCity() {
        coordinator?.navigate(.addCity)
    }
}

extension WeatherListViewController {
    func configureTableView() {
        tableView.register(CityTableViewCell.self)
        tableView.separatorStyle = .none
    }
}

extension WeatherListViewController: WeatherListViewProtocol {
    func configure(with viewModels: [CityCellViewModel]) {
        self.viewModels.removeAll()
        self.viewModels.append(contentsOf: viewModels)
        tableView.reloadData()
    }
}
