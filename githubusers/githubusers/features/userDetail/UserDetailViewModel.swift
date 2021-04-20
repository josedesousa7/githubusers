//
//  UserDetailViewModel.swift
//  githubusers
//
//  Created by José Marques on 20/04/2021.
//  Copyright © 2021 José Marques. All rights reserved.
//

import Foundation
import UIKit

protocol UserDetailViewModelProtocol: AnyObject {
    func showUserImage(user: GitHubUser, completion: @escaping (_ image: UIImage?) -> Void)
    func showUserWithName(name: String, completion: @escaping (Result<[GitHubUser], Error>) -> Void)
}

class UserDetailViewModel: UserDetailViewModelProtocol {
    
    // MARK: - Properties
    private var dataSource: DataProviderProtocol
    
    // MARK: - Initializers
    init (dataSource: DataProviderProtocol) {
        self.dataSource = dataSource
    }
    
    // MARK: - Public methods
    
    func showUserImage(user: GitHubUser, completion: @escaping (UIImage?) -> Void) {
        if let avatar = user.avatarUrl {
            dataSource.fetchUserImage(avatarUrl: avatar) { result in
                completion(result)
            }
        } else {
            completion(UIImage(named: "placeholder"))
        }
    }
    
    func showUserWithName(name: String, completion: @escaping (Result<[GitHubUser], Error>) -> Void) {
        dataSource.fetchUserDetail(user: name){ result in
            switch result {
            case .success(let users):
                completion(.success(Array(arrayLiteral: users)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
