//
//  CityListResponse.swift
//  CVApp
//
//  Created by Piotr Furmanski on 23/07/2020.
//  Copyright © 2020 Piotr Furmanski. All rights reserved.
//

import Foundation

public struct CityListResponse: Codable {
    let cityList: [CityModel]
    
    public init(cityList: [CityModel]) {
        self.cityList = cityList
    }
}
