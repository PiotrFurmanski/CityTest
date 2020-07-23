//
//  CvModel.swift
//  CVApp
//
//  Created by Piotr Furmanski on 23/07/2020.
//  Copyright © 2020 Piotr Furmanski. All rights reserved.
//

import Foundation

struct CvModel: Codable {
    var summary: String?
    var personalData: PersonalData
    var education: [String: Education]
    var experience: [String: Experience]
}

struct PersonalData: Codable {
    var firstName: String
    var lastName: String
    var country: String
    var city: String
    var phoneNumber: String?
}

struct Education: Codable {
    var startDate: Int
    var endDate: Int
}

struct Experience: Codable {
    var startDate: Int
    var endDate: Int
    var role: String
    var description: String
}
