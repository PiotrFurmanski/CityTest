//
//  CVAppTests.swift
//  CVAppTests
//
//  Created by Piotr Furmanski on 23/07/2020.
//  Copyright © 2020 Piotr Furmanski. All rights reserved.
//

import XCTest
@testable import CityApp

class CityListViewModelTests: XCTestCase {
    
    private struct Constatns {
        static let timeout = 2.0
        static let description = "Loading end"
    }
    
    let service = CityServiceMock()
    let delegate = CityListViewMock()
    var viewModel: CityListViewModel!

    override func setUpWithError() throws {
        viewModel = CityListViewModel(service: service, delegate: delegate)
    }

    func testLoadDataNoError() throws {
        let expect = expectation(description: Constatns.description)
        viewModel.loadData() {
            expect.fulfill()
        }
        waitForExpectations(timeout: Constatns.timeout, handler: nil)
        XCTAssertEqual(viewModel.cityModels.count, 2)
        XCTAssertTrue(delegate.stopLoadingIndicatorCalled)
        XCTAssertTrue(delegate.reloadCalled)
    }
    
    func testLoadDataError() throws {
        let expect = expectation(description: Constatns.description)
        service.isFaultOccurs = true
        viewModel.loadData() {
            expect.fulfill()
        }
        waitForExpectations(timeout: Constatns.timeout, handler: nil)
        XCTAssertEqual(viewModel.cityModels.count, 0)
        XCTAssertTrue(delegate.stopLoadingIndicatorCalled)
        XCTAssertFalse(delegate.error.isEmpty)
    }

}
