//
//  CityDetailsViewModelTests.swift
//  CityAppTests
//
//  Created by Piotr Furmanski on 28/07/2020.
//  Copyright © 2020 Piotr Furmanski. All rights reserved.
//

import XCTest
import Services
@testable import CityApp

class CityDetailsViewModelTests: XCTestCase {
    
    private struct Constants {
        static let timeout = 2.0
        static let description = "Loading end"
        static let favourites = "favourites"
    }
    
    let service = CityServiceMock()
    let delegate = CityDetailsViewMock()
    
    let cityModel = CityModel(name: "London",
                              imageUrl: "",
                              cityId: 1,
                              rateUrl: "",
                              touristsUrl: "")
    
    var viewModel: CityDetailsViewModel!

    override func setUpWithError() throws {
        viewModel = CityDetailsViewModel(service: service,
                                         delegate: delegate,
                                         cityModel: cityModel)
    }
    
    func testGetData() {
        let expect = expectation(description: Constants.description)
        viewModel.getData() {
            expect.fulfill()
        }
        waitForExpectations(timeout: Constants.timeout, handler: nil)
        XCTAssertEqual(viewModel.touritsLabelText, "Tourists amount: 2")
        XCTAssertEqual(viewModel.ratingLabelText, "Avarage rating: 5.0")
        XCTAssertTrue(delegate.stopLoadingIndicatorCalled)
        XCTAssertTrue(delegate.reloadCalled)
        XCTAssertTrue(delegate.error.isEmpty)
    }
    
    func testGetDataError() {
        service.isFaultOccurs = true
        let expect = expectation(description: Constants.description)
        viewModel.getData() {
            expect.fulfill()
        }
        waitForExpectations(timeout: Constants.timeout, handler: nil)
        XCTAssertEqual(viewModel.touritsLabelText, "Tourists amount: 0")
        XCTAssertEqual(viewModel.ratingLabelText, "Avarage rating:")
        XCTAssertTrue(delegate.stopLoadingIndicatorCalled)
        XCTAssertTrue(delegate.reloadCalled)
        XCTAssertFalse(delegate.error.isEmpty)
    }
    
    func testFavouriteChange() {
        viewModel.favouriteChange(to: false)
        XCTAssertFalse(viewModel.isFavourite)
        viewModel.favouriteChange(to: true)
        XCTAssertTrue(viewModel.isFavourite)
    }

}
