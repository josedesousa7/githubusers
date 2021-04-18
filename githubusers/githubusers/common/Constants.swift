//
//  Constants.swift
//  githubusers
//
//  Created by José Marques on 18/04/2021.
//  Copyright © 2021 José Marques. All rights reserved.
//

import Foundation

public enum Constants {

    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Plist file not found")
        }
        return dict
    }()

    static let baseUrl: String = {
        guard let baseUrl = Constants.infoDictionary[Keys.Plist.baseUrl] as? String else {
            fatalError("API Key not set in plist for this environment")
        }
        return baseUrl
    }()

    static let apiSlash = "/"
}
