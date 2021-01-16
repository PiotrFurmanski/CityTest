//
//  CityTouristsModel.swift
//  CityApp
//
//  Created by Piotr Furmanski on 25/07/2020.
//  Copyright © 2020 Piotr Furmanski. All rights reserved.
//

import Foundation

public struct CityTouristsModel: Codable {
    let tourists: [String]
    
    public init(tourists: [String]) {
        self.tourists = tourists
    }
}

