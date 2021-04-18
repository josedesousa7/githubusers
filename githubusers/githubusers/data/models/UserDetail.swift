//
//  UserDetail.swift
//  githubusers
//
//  Created by José Marques on 18/04/2021.
//  Copyright © 2021 José Marques. All rights reserved.
//

import Foundation

struct UserDetail: Codable {
    let login: String?
    let avatarUrl : String?
    let name: String?
    let htmlUrl: String?
    let company: String?
    let publicRepos: Int?

    enum CodingKeys: String, CodingKey {
        case login = "login"
        case avatarUrl = "avatar_url"
        case name = "name"
        case htmlUrl = "html_url"
        case company = "company"
        case publicRepos = "public_repos"
    }
}

