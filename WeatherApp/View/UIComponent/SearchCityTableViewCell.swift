//
//  SearchCityTableViewCell.swift
//  WeatherApp
//
//  Created by Hai Le Thanh on 4/15/20.
//  Copyright © 2020 Hai Le. All rights reserved.
//

import UIKit

struct SearchCityCellViewModel: BaseViewModel {
    let cityName: String
    let isAdded: Observable<Bool>
}

protocol SearchCityTableViewCellDelegate: class {
    func searchCityCellDidTapButton(_ cell: SearchCityTableViewCell)
}

class SearchCityTableViewCell: UITableViewCell, Reuseable, ViewConfigurable {
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var editButton: UIButton!
    weak var delegate: SearchCityTableViewCellDelegate?
    private var viewModel: SearchCityCellViewModel?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel?.isAdded.valueChanged = nil
    }
    
    func configure(with viewModel: BaseViewModel) {
        guard let viewModel = viewModel as? SearchCityCellViewModel else { return }
        
        self.viewModel = viewModel
        nameLabel.text = viewModel.cityName
        configureButtonImage(added: viewModel.isAdded.value)
        
        viewModel.isAdded.valueChanged = { value in
            self.configureButtonImage(added: value)
        }
    }
    
    private func configureButtonImage(added: Bool) {
        let imageName = added ? "tick" : "add"
        editButton.setImage(UIImage(named: imageName), for: .normal)
    }
    
    @IBAction func editBtnTapped(_ sender: Any) {
        delegate?.searchCityCellDidTapButton(self)
    }
}
