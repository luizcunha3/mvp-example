//
//  Repositories.swift
//  HubRep
//
//  Created by Tomaz Correa da Silva on 28/11/18.
//  Copyright © 2018 hubrep. All rights reserved.
//

import Foundation

struct Repository: Codable {
    let name: String?
    let owner: Owner?
    let htmlUrl: String?
    let description: String?
    let createdAt: String?
    let stargazersCount: Int?
    let language: String?
    let forks: Int?
    let openIssues: Int?
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case owner = "owner"
        case htmlUrl = "html_url"
        case description = "description"
        case createdAt = "created_at"
        case stargazersCount = "stargazers_count"
        case language = "language"
        case forks = "forks"
        case openIssues = "open_issues"
    }
}

struct Owner: Codable {
    let login: String?
    let avatarUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case login = "login"
        case avatarUrl = "avatar_url"
    }
}
