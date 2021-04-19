//
//  UserTableViewCellViewModel.swift
//  githubusers
//
//  Created by José Marques on 19/04/2021.
//  Copyright © 2021 José Marques. All rights reserved.
//

import Foundation
import UIKit

class UserTableViewCellViewModel {

    // MARK: - Properties
    private(set) var model: GitHubUser
    private var dataSource: DataProviderProtocol

    // MARK: - Initializers
    init(model: GitHubUser, dataSource: DataProviderProtocol) {
        self.model = model
        self.dataSource = dataSource
    }

    // MARK: - Public methods

    func showUserImage(_ completion: @escaping (_ image: UIImage?) -> Void) {
        if let avatar = model.avatarUrl {
            dataSource.fetchUserImage(avatarUrl: avatar) { result in
                completion(result)
            }
        } else {
            completion(UIImage(named: "placeholder"))
        }
    }
}
