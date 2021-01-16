//
//  CityRateModel.swift
//  CityApp
//
//  Created by Piotr Furmanski on 25/07/2020.
//  Copyright © 2020 Piotr Furmanski. All rights reserved.
//

import Foundation

public struct CityRateModel: Codable {
    let rate: Double
    
    public init(rate: Double) {
        self.rate = rate
    }
}

