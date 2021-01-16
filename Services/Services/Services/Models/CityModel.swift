//
//  CityModel.swift
//  CVApp
//
//  Created by Piotr Furmanski on 23/07/2020.
//  Copyright © 2020 Piotr Furmanski. All rights reserved.
//

import Foundation

public struct CityModel: Codable {
    public let name: String
    public let imageUrl: String
    public let cityId: Int
    public let rateUrl: String
    public let touristsUrl: String
    
    public init(name: String, imageUrl: String, cityId: Int, rateUrl: String, touristsUrl: String) {
        self.name = name
        self.imageUrl = imageUrl
        self.cityId = cityId
        self.rateUrl = rateUrl
        self.touristsUrl = touristsUrl
    }
}
