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


protocol CityServiceProtocol: AnyObject {
    func getCityList(completion: @escaping (Result<[CityModel], Error>) -> Void)
    func getCity(for url: String, completion: @escaping (Result<CityModel, Error>) -> Void)
}

class CityService: CityServiceProtocol {
    private struct Constanst {
        static let baseUrl = "https://gist.githubusercontent.com/PiotrFurmanski/"
        static let cityListEndpoint = "115dd75791870216934e3d27e919367f/raw/b1c901bde7341cc9ef3622fd3a0d8ddeaa1d9895/cityList"
    }
    
    func getCityList(completion: @escaping (Result<[CityModel], Error>) -> Void) {
        guard let url = URL(string: "\(Constanst.baseUrl)\(Constanst.cityListEndpoint)") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
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
                let response = try decoder.decode(CityListResponse.self, from: data)

                completion(.success(response.cityList))
                
            } catch let error {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func getCity(for url: String, completion: @escaping (Result<CityModel, Error>) -> Void) {
        guard let url = URL(string: url) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
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
                let cityModel = try decoder.decode(CityModel.self, from: data)
                completion(.success(cityModel))
            } catch let error {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

