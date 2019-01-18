//
//  SearchPresenter.swift
//  HubRep
//
//  Created by Tomaz Correa da Silva on 27/11/18.
//  Copyright (c) 2018 hubrep. All rights reserved.
//

import Foundation
import SystemConfiguration

// MARK: - STRUCT VIEW DATA -
struct ViewData {
    var ownerName = ""
    var ownerAvatar = ""
    var repositories = [RepositoryViewData()]
}

struct RepositoryViewData {
    var name = ""
    var url = ""
    var starsNumber = ""
    var forksNumber = ""
    var issuesNumber = ""
    var description = "Não existe descrição para este respositório!"
    var language = ""
    var creationDate = ""
}

// MARK: - VIEW DELEGATE -
protocol HomeViewDelegate: NSObjectProtocol {
    func showRepositories(viewData: ViewData)
    func showFindError(type: String)
}

// MARK: - PRESENTER CLASS -
class HomePresenter {
    private weak var viewDelegate: HomeViewDelegate!
    private lazy var viewData = ViewData()
    private lazy var service = RepositoryService()
    
    init(viewDelegate: HomeViewDelegate) {
        self.viewDelegate = viewDelegate
    }
}

//SERVICE
extension HomePresenter {
    func getRepositories(ownerName: String) {
        if isConnectedToNetwork() {
            self.callService(ownerName)
        } else {
            self.viewDelegate.showFindError(type: Constants.FindErrorType.connectionError)
        }
    }
    
    private func callService(_ ownerName: String) {
        self.service.getRepositories(ownerName: ownerName, errorCompletion: { (_) in
            self.viewDelegate.showFindError(type: Constants.FindErrorType.udefinedError)
        }, successCompletion: { (repositories) in
            self.processServiceReturn(repositories)
        })
    }
    
    private func processServiceReturn(_ repositories: ([Repository])) {
        if repositories.count > 0 {
            self.createViewData(repositories)
            self.viewDelegate.showRepositories(viewData: self.viewData)
        } else {
            self.viewDelegate.showFindError(type: Constants.FindErrorType.emptyResult)
        }
    }
}

//AUX METHODS
extension HomePresenter {
    private func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) { zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    private func createViewData(_ repositories: [Repository]) {
        self.viewData = ViewData()
        self.viewData.repositories.removeAll()
        for repository in repositories {
            if let owner = repository.owner,
               let ownerName = owner.login,
               let ownerAvatar = owner.avatarUrl {
                self.viewData.ownerName = ownerName
                self.viewData.ownerAvatar = ownerAvatar
            }
            if let repositoryViewData = self.createRepositoryViewData(repository: repository) {
                 self.viewData.repositories.append(repositoryViewData)
            }
        }
    }
    
    private func createRepositoryViewData(repository: Repository) -> RepositoryViewData? {
        guard let name = repository.name,
            !name.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty else { return nil }
        var repositoryViewData = RepositoryViewData()
        repositoryViewData.name = name
        if let url = repository.htmlUrl {
            repositoryViewData.url = url
        }
        if let starsNumber = repository.stargazersCount {
            repositoryViewData.starsNumber = String(starsNumber)
        }
        if let forksNumber = repository.forks {
            repositoryViewData.forksNumber = String(forksNumber)
        }
        if let issuesNumber = repository.openIssues {
            repositoryViewData.issuesNumber = String(issuesNumber)
        }
        if let description = repository.description {
            repositoryViewData.description = description
        }
        if let language = repository.language {
            repositoryViewData.language = language
        }
        if let creationDate = repository.createdAt,
           let finalDate = formatDate(creationDate) {
            repositoryViewData.creationDate = finalDate
        }
        return repositoryViewData
    }
    
    private func formatDate(_ date: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        let finalDateFormatter = DateFormatter()
        finalDateFormatter.dateFormat = "dd/MM/yyyy"
        if let date = dateFormatter.date(from: date) {
            return finalDateFormatter.string(from: date)
        }
        return nil
    }
}
