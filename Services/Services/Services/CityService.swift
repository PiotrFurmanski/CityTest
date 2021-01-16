//
//  CVService.swift
//  CVApp
//
//  Created by Piotr Furmanski on 16/01/2021.
//  Copyright © 2021 Piotr Furmanski. All rights reserved.
//

import Foundation

public enum ServiceError: Error {
    case emptyData
}


public protocol CityServiceProtocol: AnyObject {
    func getCityList(completion: @escaping (Result<[CityModel], Error>) -> Void)
    func getCityTourists(for urlString: String, completion: @escaping (Result<[String], Error>) -> Void)
    func getCityRating(for urlString: String, completion: @escaping (Result<Double, Error>) -> Void)
}

public class CityService: CityServiceProtocol {
    private struct Constanst {
        static let baseUrl = "https://gist.githubusercontent.com/PiotrFurmanski/"
        static let cityListEndpoint = "115dd75791870216934e3d27e919367f/raw/d8bddbe0a5eda0ff81893973e239f411978c73d4/cityList"
    }
    
    public init(){}

    public func getCityList(completion: @escaping (Result<[CityModel], Error>) -> Void) {
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
    
    public func getCityTourists(for urlString: String, completion: @escaping (Result<[String], Error>) -> Void) {
        guard let url = URL(string: urlString) else { return }
        
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
                let touristsResponse = try decoder.decode(CityTouristsModel.self, from: data)
                completion(.success(touristsResponse.tourists))
            } catch let error {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    public func getCityRating(for urlString: String, completion: @escaping (Result<Double, Error>) -> Void) {
        guard let url = URL(string: urlString) else { return }
        
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
                let ratingResponse = try decoder.decode(CityRateModel.self, from: data)
                completion(.success(ratingResponse.rate))
            } catch let error {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

