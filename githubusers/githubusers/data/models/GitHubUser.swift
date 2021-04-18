//
//  GitHubUser.swift
//  githubusers
//
//  Created by José Marques on 18/04/2021.
//  Copyright © 2021 José Marques. All rights reserved.
//

import Foundation

struct GitHubUser: Codable {
    let login: String?
    let avatarUrl : String?

    enum CodingKeys: String, CodingKey {
        case login = "login"
        case avatarUrl = "avatar_url"
    }
}
