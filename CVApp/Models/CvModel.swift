//
//  CvModel.swift
//  CVApp
//
//  Created by Piotr Furmanski on 23/07/2020.
//  Copyright © 2020 Piotr Furmanski. All rights reserved.
//

import Foundation

struct CvModel: Codable {
    let summary: String?
    let personalData: PersonalData
    let education: [String: Education]
    let experience: [String: Experience]
}

struct PersonalData: Codable {
    let firstName: String
    let lastName: String
    let country: String
    let city: String
    let phoneNumber: String?
}

struct Education: Codable {
    let startDate: Int
    let endDate: Int
}

struct Experience: Codable {
    let startDate: Int
    let endDate: Int
    let role: String
    let description: String
}
