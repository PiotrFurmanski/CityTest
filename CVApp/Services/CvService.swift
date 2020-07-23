//
//  CVService.swift
//  CVApp
//
//  Created by Piotr Furmanski on 23/07/2020.
//  Copyright © 2020 Piotr Furmanski. All rights reserved.
//

import Foundation

enum ServiceError: Error {
    case emptyData
}


protocol CvServiceProtocol: AnyObject {
    func getCvList(completion: @escaping (Result<[String: CvFile], Error>) -> Void)
    func getCv(for url: String, completion: @escaping (Result<CvModel, Error>) -> Void)
}

class CvService: CvServiceProtocol {
    private struct Constanst {
        static let url = "https://api.github.com/users/piotrfurmanski/gists"
    }
    
    func getCvList(completion: @escaping (Result<[String: CvFile], Error>) -> Void) {
        guard let url = URL(string: Constanst.url) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(ServiceError.emptyData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode([CvListResponse].self, from: data)
                if let files = response.first?.files {
                    completion(.success(files))
                } else {
                    completion(.failure(ServiceError.emptyData))
                }
                
            } catch let error {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func getCv(for url: String, completion: @escaping (Result<CvModel, Error>) -> Void) {
        guard let url = URL(string: url) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(ServiceError.emptyData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let cvModel = try decoder.decode(CvModel.self, from: data)
                completion(.success(cvModel))
            } catch let error {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

