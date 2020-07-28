//
//  CityListViewMock.swift
//  CityAppTests
//
//  Created by Piotr Furmanski on 28/07/2020.
//  Copyright © 2020 Piotr Furmanski. All rights reserved.
//

import UIKit
@testable import CityApp

class CityListViewMock: CityListViewProtocol {
    var reloadCalled = false
    var showDetailsCalled = false
    var stopLoadingIndicatorCalled = false
    var error = ""
    
    func reload() {
        reloadCalled = true
    }
    
    func showDetails(for city: CityModel, image: UIImage?) {
        showDetailsCalled = true
    }
    
    func stopLoadingIndicator() {
        stopLoadingIndicatorCalled = true
    }
    
    func show(error: String) {
        self.error = error
    }
    
    
}
