//
//  MockDataProvider.swift
//  githubusersTests
//
//  Created by José Marques on 20/04/2021.
//  Copyright © 2021 José Marques. All rights reserved.
//

import Foundation
import UIKit
@testable import githubusers

class MockDataProvider: DataProviderProtocol {

    public var responseType: ResponseType = .success

    var mockDataSurce: HttpProtocol

    init (mockDataSurce: HttpProtocol) {

        self.mockDataSurce = mockDataSurce
    }

    func fetchUsersList(completion: @escaping (Result<[GitHubUser], Error>) -> Void) {

        mockDataSurce.get("") { (_ result: Result<[GitHubUser], Error>) in
            switch self.responseType {
            case .success:
                switch result {
                case .success(let userList):
                    completion(.success(userList))
                case .failure(let error):
                    completion(.failure(error))
                }
            case .failure:
                completion(.failure(HttpRequestError.unavailable))
            }
        }
    }

    func fetchUserDetail(user: String, completion: @escaping (Result<GitHubUser, Error>) -> Void) {
        mockDataSurce.get("") { (_ result: Result<GitHubUser, Error>) in
            switch self.responseType {
            case .success:
                switch result {
                case .success(let user):
                    completion(.success(user))
                case .failure(let error):
                    completion(.failure(error))
                }
            case .failure:
                completion(.failure(HttpRequestError.unavailable))
            }
        }
    }

    func fetchUserImage(avatarUrl: String, _ completion: @escaping (UIImage) -> Void) {
        completion(UIImage(named: "placeholder")!)
    }
}
