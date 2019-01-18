//
//  SerchService.swift
//  HubRep
//
//  Created by Tomaz Correa da Silva on 28/11/18.
//  Copyright © 2018 hubrep. All rights reserved.
//

import Foundation
import Alamofire

enum ServiceError: Error {
    case Error
}

class RepositoryService {
    private let path = "https://api.github.com/users/%@/repos?type=owner&sort=updated&direction=desc"
    func getRepositories(ownerName: String,
                         errorCompletion: @escaping(_ error: ServiceError?) -> Void,
                         successCompletion: @escaping(_ repositories: [Repository]) -> Void) {
        let serviceUrl = String(format: self.path, ownerName)
        Alamofire.request(serviceUrl).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success:
                guard let data = response.data else { return errorCompletion(.Error) }
                do {
                    let repositories = try JSONDecoder().decode([Repository].self, from: data)
                    successCompletion(repositories)
                } catch {
                    errorCompletion(.Error)
                }
            case .failure:
                errorCompletion(.Error)
            }
        })
    }
}
