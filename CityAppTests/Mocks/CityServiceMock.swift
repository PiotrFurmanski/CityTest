//
//  CityServiceMock.swift
//  CityAppTests
//
//  Created by Piotr Furmanski on 28/07/2020.
//  Copyright © 2020 Piotr Furmanski. All rights reserved.
//

import Foundation
@testable import CityApp

class CityServiceMock: CityServiceProtocol {
    enum CustomError: Error {
        case someError
    }
    
    var isFaultOccurs = false
    func getCityList(completion: @escaping (Result<[CityModel], Error>) -> Void) {
        isFaultOccurs ? completion(.failure(CustomError.someError)) :
                        completion(.success([CityModel(name: "Warsaw", imageUrl: "",
                                                       cityId: 1, rateUrl: "",
                                                       touristsUrl: ""),
                                             CityModel(name: "London", imageUrl: "",
                                                       cityId: 2, rateUrl: "",
                                                       touristsUrl: "")]))
    }
    
    func getCityTourists(for urlString: String, completion: @escaping (Result<[String], Error>) -> Void) {
        isFaultOccurs ? completion(.failure(CustomError.someError)) :
                        completion(.success(["Jonny", "Pamela"]))
    }
    
    func getCityRating(for urlString: String, completion: @escaping (Result<Double, Error>) -> Void) {
        completion(.success(5))
    }
    
    
}
