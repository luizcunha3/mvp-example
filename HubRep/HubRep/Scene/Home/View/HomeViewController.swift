//
//  SearchViewController.swift
//  HubRep
//
//  Created by Tomaz Correa da Silva on 27/11/18.
//  Copyright (c) 2018 hubrep. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: OUTLETS
    @IBOutlet weak var searchCardView: UIView!
    @IBOutlet weak var searchImage: UIImageView!
    @IBOutlet weak var ownerNameTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var loadingActivity: UIActivityIndicatorView!
    @IBOutlet weak var errorLabel: UILabel!
    
    // MARK: VARIABLES
    private var presenter: HomePresenter!
    private lazy var viewData: ViewData = ViewData()
    
    // MARK: IBACTIONS
    @IBAction func findRepositories(_ sender: Any) {
        self.find()
    }
}

// MARK: - LIFE CYCLE -
extension HomeViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter = HomePresenter(viewDelegate: self)
        self.setupNavigationController()
        self.setupSearchCardView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.searchButton.alpha = 1
        self.loadingActivity.alpha = 0
    }
}

// MARK: - PRESENTER -
extension HomeViewController: HomeViewDelegate {
    func showFindError(type: String) {
        self.showError(type: type)
    }
    
    func showRepositories(viewData: ViewData) {
        self.viewData = viewData
        self.performSegue(withIdentifier: Constants.Segues.repositories, sender: self)
    }
}

// MARK: - SEGUES -
extension HomeViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let repositoriesVC = segue.destination as? RepositoriesViewController {
            repositoriesVC.viewData = self.viewData
        }
    }
}

// MARK: - AUX METHODS -
extension HomeViewController {
    private func setupNavigationController() {
        self.navigationController?.navigationBarCustomize()
    }
    
    private func setupSearchCardView() {
        self.searchCardView.layer.masksToBounds = false
        self.searchCardView.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.searchCardView.layer.shadowColor = Constants.Colors.cardShadowColor.cgColor
        self.searchCardView.layer.shadowRadius = 3
        self.searchCardView.layer.shadowOpacity = 1
    }
    
    private func find() {
        guard let ownerName = self.ownerNameTextField.text,
            !ownerName.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty else { return }
        let transitionOptions: UIView.AnimationOptions = [.transitionFlipFromRight, .curveEaseInOut, .repeat]
        UIView.animate(withDuration: 0.4, animations: {
            self.errorLabel.isHidden = true
            self.searchButton.alpha = 0
            self.loadingActivity.alpha = 1
        }, completion: { _ -> Void in
            UIView.transition(with: self.searchImage, duration: 1, options: transitionOptions, animations: {
                self.searchImage.alpha = 0
            }, completion: { _ -> Void in
                self.presenter.getRepositories(ownerName: ownerName)
            })
            UIView.transition(with: self.searchImage, duration: 1, options: transitionOptions, animations: {
                self.searchImage.alpha = 1
            })
        })
    }
    
    private func showError(type: String) {
        self.searchImage.layer.removeAllAnimations()
        switch type {
        case Constants.FindErrorType.connectionError:
            self.errorLabel.text = Constants.FindErrorMessage.connectionError
        case Constants.FindErrorType.emptyResult:
            self.errorLabel.text = Constants.FindErrorMessage.emptyResult
        case Constants.FindErrorType.udefinedError:
            self.errorLabel.text = Constants.FindErrorMessage.udefinedError
        default:
            break
        }
        self.showErrorLabel()
    }
    
    private func showErrorLabel() {
        UIView.animate(withDuration: 0.4, animations: {
            self.errorLabel.isHidden = false
            self.searchButton.alpha = 1
            self.loadingActivity.alpha = 0
        })
    }
}
