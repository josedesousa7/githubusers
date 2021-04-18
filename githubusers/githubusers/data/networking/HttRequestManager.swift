//
//  HttRequestManager.swift
//  githubusers
//
//  Created by José Marques on 18/04/2021.
//  Copyright © 2021 José Marques. All rights reserved.
//

import Foundation
import  Alamofire
import AlamofireImage

protocol HttpProtocol {
    func get<T> (_ requestUrl : String, _ completion: @escaping (Result<T, HttpRequestError>) -> Void) where T: Codable
    func requestImage(_ requestUrl: String, _ completion: @escaping (_ image: UIImage) -> Void)
}

class HttpRequestManager: HttpProtocol  {

    func get<T>(_ requestUrl: String, _ completion: @escaping (Result<T, HttpRequestError>) -> Void) where T : Codable {
        AF.request(requestUrl).responseJSON { response in
            switch response.result {
            case .success:
                let decoder = JSONDecoder()
                guard let data = response.data else {
                    completion(.failure(.requestFailed))
                    return
                }
                do {
                    let decoded = try decoder.decode(T.self, from: data)
                    completion(.success(decoded))
                } catch let error {
                    print("Decoding Error:\(error.localizedDescription)")
                    completion(.failure(.decoding))
                }
            case .failure(let error):
                print("Error:\(error.localizedDescription)")
                completion(.failure(.unavailable))
            }
        }
    }

    func requestImage(_ requestUrl: String, _ completion: @escaping (_ image: UIImage) -> Void) {
        guard let defaultImage = UIImage(named: "placeholder") else { return }
        AF.request(requestUrl).responseImage { response in
            switch response.result {
            case .success(let image):
                completion(image)
                break
            case .failure(let error):
                print(error.localizedDescription)
                completion(defaultImage)
                break
            }
        }
    }
}

enum HttpRequestError: Error {
    case unavailable
    case requestFailed
    case decoding
}
