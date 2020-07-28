//
//  CityDetailsViewMock.swift
//  CityAppTests
//
//  Created by Piotr Furmanski on 28/07/2020.
//  Copyright © 2020 Piotr Furmanski. All rights reserved.
//

import UIKit
@testable import CityApp

class CityDetailsViewMock: CityDetailsViewProtocol {
    var reloadCalled = false
    var stopLoadingIndicatorCalled = false
    var error = ""
    
    func reload() {
        reloadCalled = true
    }
    
    func stopLoadingIndicator() {
        stopLoadingIndicatorCalled = true
    }
    
    func show(error: String) {
        self.error = error
    }
    

}
