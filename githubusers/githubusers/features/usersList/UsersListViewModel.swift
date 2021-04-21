//
//  UsersListViewModel.swift
//  githubusers
//
//  Created by José Marques on 19/04/2021.
//  Copyright © 2021 José Marques. All rights reserved.
//

import Foundation
import UIKit

protocol UsersListViewModelProtocol: AnyObject {
    func showUsersList(completion: @escaping (Result<[GitHubUser], Error>) -> Void)
    func showUserWithName(name: String, completion: @escaping (Result<[GitHubUser], Error>) -> Void)
}

class UsersListViewModel: UsersListViewModelProtocol  {

    // MARK: - Properties
    private var dataSource: DataProviderProtocol

    // MARK: - Initializers

    init (dataSource: DataProviderProtocol) {
        self.dataSource = dataSource
    }

    // MARK: - Public methods

    func showUsersList(completion: @escaping (Result<[GitHubUser], Error>) -> Void) {
        dataSource.fetchUsersList { result in
            switch result {
            case .success(let users):
                completion(.success(users))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func showUserWithName(name: String, completion: @escaping (Result<[GitHubUser], Error>) -> Void) {
        dataSource.fetchUserDetail(user: name) { result in
            switch result {
            case .success(let users):
                completion(.success(Array(arrayLiteral: users)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
