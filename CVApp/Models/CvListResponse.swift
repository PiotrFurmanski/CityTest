//
//  CvListResponse.swift
//  CVApp
//
//  Created by Piotr Furmanski on 23/07/2020.
//  Copyright © 2020 Piotr Furmanski. All rights reserved.
//

import Foundation

struct CvListResponse: Codable {
    let files: [String: CvFile]
}

struct CvFile: Codable {
    let filename: String
    let url: String
    
    private enum CodingKeys: String, CodingKey {
        case filename
        case url = "raw_url"
    }
}
