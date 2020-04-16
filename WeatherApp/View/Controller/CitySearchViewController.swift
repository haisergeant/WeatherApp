//
//  CitySearchViewController.swift
//  WeatherApp
//
//  Created by Hai Le Thanh on 4/15/20.
//  Copyright © 2020 Hai Le. All rights reserved.
//

import UIKit

protocol CitySearchViewProtocol: class {
    func configure(with viewModels: [SearchCityCellViewModel])
}

class CitySearchViewController: UIViewController {
    
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var searchTableView: UITableView!
    private var viewModel: CitySearchViewModelProtocol?
    private var viewModels: [SearchCityCellViewModel] = []
    
    func setup(with viewModel: CitySearchViewModelProtocol) {
        self.viewModel = viewModel
        viewModel.bind(to: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        searchTableView.dataSource = self
        searchTableView.register(SearchCityTableViewCell.self)
        
        title = "Add new city"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeView))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel?.saveSelection()
    }
    
    @objc private func closeView() {
        dismiss(animated: true, completion: nil)
    }
}

extension CitySearchViewController: CitySearchViewProtocol {
    func configure(with viewModels: [SearchCityCellViewModel]) {
        self.viewModels.removeAll()
        self.viewModels.append(contentsOf: viewModels)
        searchTableView.reloadData()
    }
}

extension CitySearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel?.searchCity(searchText)
    }
}

extension CitySearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SearchCityTableViewCell = tableView.dequeueReuseableCell(indexPath: indexPath)
        cell.configure(with: viewModels[indexPath.row])
        cell.delegate = self
        return cell
    }
}

extension CitySearchViewController: SearchCityTableViewCellDelegate {
    func searchCityCellDidTapButton(_ cell: SearchCityTableViewCell) {
        guard let indexPath = searchTableView.indexPath(for: cell) else { return }
        
        viewModel?.toggleItem(at: indexPath.row)
    }
}
