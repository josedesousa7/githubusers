//
//  DataProvider.swift
//  githubusers
//
//  Created by José Marques on 18/04/2021.
//  Copyright © 2021 José Marques. All rights reserved.
//

import Foundation
import UIKit

protocol DataProviderProtocol: AnyObject {
    func fetchUsersList(completion: @escaping (Result<[GitHubUser], Error>) -> Void)
    func fetchUserDetail(user: String, completion: @escaping (Result<GitHubUser, Error>) -> Void)
    func fetchUserImage(avatarUrl: String, _ completion: @escaping (_ image: UIImage) -> Void) 
}

class DataProvider: DataProviderProtocol  {

    private var dataSource: HttpProtocol

    init (dataSource: HttpProtocol) {
        self.dataSource = dataSource
    }

    func fetchUsersList(completion: @escaping (Result<[GitHubUser], Error>) -> Void) {
        dataSource.get(Constants.baseUrl) { (_ result: Result<[GitHubUser], Error>) in
            switch result {
            case .success(let repositoryList):
                completion(.success(repositoryList))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func fetchUserDetail(user: String, completion: @escaping (Result<GitHubUser, Error>) -> Void) {
        dataSource.get(Constants.baseUrl + Constants.apiSlash + user) { (_ result: Result<GitHubUser, Error>) in
            switch result {
            case .success(let userDetail):
                if let _ = userDetail.login {
                    completion(.success(userDetail))
                } else {
                    completion(.failure(EmptyRequestError.notFound))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func fetchUserImage(avatarUrl: String, _ completion: @escaping (_ image: UIImage) -> Void) {
        dataSource.requestImage(avatarUrl) { result in
            completion(result)
        }
    }
}

public enum EmptyRequestError: Error {
    case notFound
}
