//
//  RepositoriesViewController.swift
//  HubRep
//
//  Created by Tomaz Correa da Silva on 28/11/18.
//  Copyright © 2018 hubrep. All rights reserved.
//

import UIKit
import Kingfisher

class RepositoriesViewController: UIViewController {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var ownerImage: UIImageView!
    @IBOutlet weak var ownerImageLoadingView: UIView!
    @IBOutlet weak var ownerName: UILabel!
    @IBOutlet weak var repositoriesTableView: UITableView!
    
    public lazy var viewData: ViewData = ViewData()
    
    private var repositoriesTableViewRows = 0
    private var selectedIndex = 0
    
    @IBAction func backToHome(_ sender: Any) {
        self.back()
    }
}

// MARK: - LIFE CYCLE -
extension RepositoriesViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.repositoriesTableView.rowHeight = UITableView.automaticDimension
        self.repositoriesTableView.estimatedRowHeight = 140.0
        self.setupSearchCardView()
        self.setOwnerImage()
        self.insertHomeTableViewRows()
    }
}

// MARK: - TABLE VIEW DATA SOURCE -
extension RepositoriesViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.repositoriesTableViewRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellNameID = Constants.Cells.repositoryTableViewCell
        tableView.register(UINib(nibName: cellNameID, bundle: nil), forCellReuseIdentifier: cellNameID)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellNameID, for: indexPath) as! RepositoryTableViewCell
        cell.hideTopSeparatorViewIfNeeded(indexPath.row)
        cell.setupRepositoryTableViewCell(self.viewData.repositories[indexPath.row])
        return cell
    }
}

// MARK: - TABLE VIEW DELEGATE -
extension RepositoriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        self.performSegue(withIdentifier: Constants.Segues.repositoryDetail, sender: self)
    }
}

// MARK: - SEGUES -
extension RepositoriesViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let repositoryDetailVC = segue.destination as? RepositoryDetailViewController {
            repositoryDetailVC.viewData = self.viewData.repositories[self.selectedIndex]
        }
    }
}

// MARK: - AUX METHODS -
extension RepositoriesViewController {
    private func setupSearchCardView() {
        self.ownerName.text = self.viewData.ownerName
        self.headerView.layer.masksToBounds = false
        self.headerView.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.headerView.layer.shadowColor = Constants.Colors.headerShadowColor.cgColor
        self.headerView.layer.shadowRadius = 2
        self.headerView.layer.shadowOpacity = 1
    }
    
    private func insertHomeTableViewRows() {
        self.insertRow(index: self.repositoriesTableViewRows)
    }
    
    private func insertRow(index: Int) {
        let indPath = IndexPath(row: index, section: 0)
        self.repositoriesTableViewRows = index + 1
        self.repositoriesTableView.insertRows(at: [indPath], with: .right)
        guard index < self.viewData.repositories.count - 1 else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            self.insertRow(index: index + 1)
        }
    }
    
    private func setOwnerImage() {
        if self.checkThatTheOwnerImageIsCached() {
            self.setOwnerImageFromChache()
        } else {
            self.setOwnerImageAfterDownload()
        }
    }
    
    private func checkThatTheOwnerImageIsCached() -> Bool {
        let result = ImageCache.default.imageCachedType(forKey: self.viewData.ownerName)
        return result.cached
    }
    
    private func setOwnerImageFromChache() {
        ImageCache.default.retrieveImage(forKey: self.viewData.ownerName, options: nil) { image, _ in
            if let image = image {
                self.ownerImage.image = image
                self.ownerImageLoadingView.alpha = 0
                self.ownerImage.alpha = 1
            }
        }
    }
    
    private func setOwnerImageAfterDownload() {
        self.ownerImageLoadingView.startShimmering()
        if let url: URL = URL(string: self.viewData.ownerAvatar) {
            let resource = ImageResource(downloadURL: url, cacheKey: self.viewData.ownerName)
            self.ownerImage.kf.setImage(with: resource, options: nil, completionHandler: { (image, _, _, _) in
                if image == nil {
                    self.ownerImage.image = UIImage(named: "avatar_default_image")
                }
                self.ownerImage.stopShimmering()
                self.hideLoadingViewAndShowImage()
            })
        }
    }
    
    private func hideLoadingViewAndShowImage() {
        self.ownerImage.alpha = 0
        self.ownerImage.layer.transform = CATransform3DMakeScale(0.5, 0.5, 0.5)
        UIView.animate(withDuration: 0.3, delay: 1.0, animations: {
            self.ownerImageLoadingView.layer.transform = CATransform3DMakeScale(0.5, 0.5, 0.5)
            self.ownerImageLoadingView.alpha = 0
        }, completion: { (_: Bool) in
            UIView.animate(withDuration: 0.3, animations: {
                self.ownerImage.alpha = 1
                self.ownerImage.layer.transform = CATransform3DScale(CATransform3DIdentity, 1, 1, 1)
            })
        })
    }
    
    private func back() {
        self.navigationController?.popViewController(animated: true)
        self.ownerImage.image = UIImage(named: "avatar_default_image")
    }
}
