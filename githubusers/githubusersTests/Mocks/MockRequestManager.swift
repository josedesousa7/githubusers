//
//  MockRequestManager.swift
//  githubusersTests
//
//  Created by José Marques on 20/04/2021.
//  Copyright © 2021 José Marques. All rights reserved.
//

import Foundation
import UIKit
@testable import githubusers

class MockHttpRequestManager: HttpProtocol {

    public var responseType: ResponseType = .success
    public var isDetailRequest = false

    func get<T>(_ requestUrl: String, _ completion: @escaping (Result<T, Error>) -> Void) where T : Decodable, T : Encodable {

        if !isDetailRequest {
            switch responseType {

            case .success:
                completion(.success([GitHubUser(login: "mock1",
                                                avatarUrl: "mock1_avatarURL",
                                                name: "mock1_name",
                                                htmlUrl: "mock1_htmlUrl",
                                                company: "mock1_company",
                                                publicRepos: 1),
                                     GitHubUser(login: "mock2",
                                                avatarUrl: "mock2_avatarURL",
                                                name: "mock2_name",
                                                htmlUrl: "mock2_htmlUrl",
                                                company: "mock2_company",
                                                publicRepos: 2),

                                     GitHubUser(login: "mock3",
                                                avatarUrl: "mock3_avatarURL",
                                                name: "mock3_name",
                                                htmlUrl: "mock3_htmlUrl",
                                                company: "mock3_company",
                                                publicRepos: 3)] as! T))
            case .failure:
                completion(.failure(HttpRequestError.unavailable))
            }
        } else {
            switch responseType {

            case .success:
                completion(.success(GitHubUser(login: "mock1",
                                               avatarUrl: "mock1_avatarURL",
                                               name: "mock1_name",
                                               htmlUrl: "mock1_htmlUrl",
                                               company: "mock1_company",
                                               publicRepos: 1) as! T))
            case .failure:
                completion(.failure(HttpRequestError.unavailable))
            }
        }
    }

    func requestImage(_ requestUrl: String, _ completion: @escaping (UIImage) -> Void) {
        completion(UIImage(named: "placeholder")!)
    }
}

public enum ResponseType: String {
    case success
    case failure
}
