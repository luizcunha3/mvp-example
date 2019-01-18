//
//  RepositoryDetailViewController.swift
//  HubRep
//
//  Created by Tomaz Correa da Silva on 29/11/18.
//  Copyright © 2018 hubrep. All rights reserved.
//

import UIKit

class RepositoryDetailViewController: UIViewController {

    @IBOutlet weak var topStackView: UIStackView!
    @IBOutlet weak var starsNumberLabel: UILabel!
    @IBOutlet weak var forksNumberLabel: UILabel!
    @IBOutlet weak var issuesNumberLabel: UILabel!
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var creationDateLabel: UILabel!
    
    public lazy var viewData: RepositoryViewData = RepositoryViewData()
    
    @IBAction func backViewController(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func openUrlInBrowser(_ sender: Any) {
        self.open()
    }
}

// MARK: - LIFE CYCLE -
extension RepositoryDetailViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = self.viewData.name
        self.setupView()
    }
}

// MARK: - AUX METHODS -
extension RepositoryDetailViewController {
    private func setupView() {
        self.setupTopStackView()
        self.setupDescriptionView()
        self.setValues()
    }
    
    private func setupTopStackView() {
        for subview in self.topStackView.subviews {
            subview.layer.masksToBounds = false
            subview.layer.shadowOffset = CGSize(width: 2, height: 2)
            subview.layer.shadowColor = Constants.Colors.cardShadowColor.cgColor
            subview.layer.shadowRadius = 2
            subview.layer.shadowOpacity = 1
            subview.layer.cornerRadius = 8
        }
    }
    
    private func setupDescriptionView() {
        self.descriptionView.layer.masksToBounds = false
        self.descriptionView.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.descriptionView.layer.shadowColor = Constants.Colors.cardShadowColor.cgColor
        self.descriptionView.layer.shadowRadius = 2
        self.descriptionView.layer.shadowOpacity = 1
    }
    
    private func setValues() {
        self.starsNumberLabel.text = self.viewData.starsNumber
        self.forksNumberLabel.text = self.viewData.forksNumber
        self.issuesNumberLabel.text = self.viewData.issuesNumber
        self.descriptionLabel.text = self.viewData.description
        self.languageLabel.text = self.viewData.language
        self.creationDateLabel.text = self.viewData.creationDate
    }
    
    private func open() {
        guard let url = URL(string: self.viewData.url) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
