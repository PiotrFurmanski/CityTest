//
//  CityModel.swift
//  CVApp
//
//  Created by Piotr Furmanski on 23/07/2020.
//  Copyright © 2020 Piotr Furmanski. All rights reserved.
//

import Foundation

struct CityModel: Codable {
    let name: String
    let imageUrl: String
    let cityId: Int
    let rateUrl: String
    let touristsUrl: String
}
