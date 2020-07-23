//
//  CVService.swift
//  CVApp
//
//  Created by Piotr Furmanski on 23/07/2020.
//  Copyright © 2020 Piotr Furmanski. All rights reserved.
//

import Foundation

protocol CvServiceProtocol: AnyObject {
    func getCvList(completion: @escaping (Result<[String: CvFile], Error>) -> Void)
}

class CvService: CvServiceProtocol {
    private struct Constanst {
        static let url = "https://api.github.com/users/piotrfurmanski/gists"
    }
    
    func getCvList(completion: @escaping (Result<[String: CvFile], Error>) -> Void) {
        guard let url = URL(string: Constanst.url) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            self?.handleResponse(data: data, response: response, error: error, completion: completion)
        }
        task.resume()
    }
    
    private func handleResponse(data: Data?,
                                response: URLResponse?,
                                error: Error?,
                                completion: @escaping (Result<[String: CvFile], Error>) -> Void) {
        if let error = error {
            completion(.failure(error))
            return
        }

        guard let data = data else {
            completion(.success([String: CvFile]()))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let response = try decoder.decode(CvListResponse.self, from: data)
            completion(.success(response.files))
        } catch let error {
            completion(.failure(error))
        }
    }
}

