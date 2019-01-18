//
//  RepositoryTableViewCell.swift
//  HubRep
//
//  Created by Tomaz Correa da Silva on 28/11/18.
//  Copyright © 2018 hubrep. All rights reserved.
//

import UIKit

class RepositoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var topSeparatorView: UIView!
    @IBOutlet weak var bottomSeparatorView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
}

// MARK: - LIFE CYCLE -
extension RepositoryTableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

// MARK: - AUX METHODS -
extension RepositoryTableViewCell {
    func setupRepositoryTableViewCell(_ repository: RepositoryViewData) {
        self.nameLabel.text = repository.name
        self.descriptionLabel.text = repository.description
    }
    
    func hideTopSeparatorViewIfNeeded(_ index: Int) {
        if index == 0 {
            self.topSeparatorView.isHidden = false
            self.titleLabel.isHidden = false
        } else {
            self.topSeparatorView.isHidden = true
            self.titleLabel.isHidden = true
        }
    }
}
