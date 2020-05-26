//
//  TitleDescriptionTableViewCell.swift
//
//  Created by Hai Le Thanh.
//  Copyright © 2020 Hai Le. All rights reserved.
//
	

import UIKit

struct TitleDescriptionCellViewModel: BaseViewModel {
    let title: String
    let description: String
    let color: Color
    
    struct Color {
        let titleColor: UIColor
        let descriptionColor: UIColor
    }
}

class TitleDescriptionTableViewCell: UITableViewCell, Reuseable, ViewConfigurable {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    func configure(with viewModel: BaseViewModel) {
        guard let viewModel = viewModel as? TitleDescriptionCellViewModel else { return }
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        
        titleLabel.textColor = viewModel.color.titleColor
        descriptionLabel.textColor = viewModel.color.descriptionColor
    }
    
}
