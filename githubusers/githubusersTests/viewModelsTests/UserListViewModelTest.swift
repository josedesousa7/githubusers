//
//  UserListViewModelTest.swift
//  githubusersTests
//
//  Created by José Marques on 21/04/2021.
//  Copyright © 2021 José Marques. All rights reserved.
//

import XCTest
@testable import githubusers

class UserListViewModelTest: XCTestCase {
    
    var provider: MockDataProvider!
    var viewModel: UsersListViewModel!
    var responseList = [GitHubUser]()
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        provider = MockDataProvider(mockDataSurce: MockHttpRequestManager())
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        provider = nil
        viewModel = nil
        responseList.removeAll()
    }
    
    func testshowUsersList_success() throws {
        let expectation = self.expectation(description: "testshowUsersList_success")
        
        // given
        provider?.responseType = .success
        viewModel = UsersListViewModel(dataSource: provider!)
        
        guard let viewModel = viewModel else {
            XCTFail("Something went wrong")
            return
        }
        
        //when
        viewModel.showUsersList { result in
            switch result {
            case .success(let repositories):
                self.responseList = repositories
                expectation.fulfill()
            case .failure(let error):
                print("Error:\(error.localizedDescription)")
                expectation.fulfill()
            }
        }
        
        //  then
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(self.responseList.count > 0)
    }
    
    func testshowUsersList_error() throws {
        let expectation = self.expectation(description: "showUsersList_error")
        
        // given
        provider?.responseType = .failure
        viewModel = UsersListViewModel(dataSource: provider!)
        var responseError: HttpRequestError = .decoding
        
        guard let viewModel = viewModel else {
            XCTFail("Something went wrong")
            return
        }
        
        //when
        viewModel.showUsersList { result in
            switch result {
            case .success(let repositories):
                self.responseList = repositories
                expectation.fulfill()
            case .failure(let error):
                print("Error:\(error.localizedDescription)")
                responseError = error as! HttpRequestError
                expectation.fulfill()
            }
        }
        
        // then
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(self.responseList.isEmpty)
        XCTAssertTrue(responseError == HttpRequestError.unavailable)
    }
    
    func testshowUserWithName_success() throws {
        let expectation = self.expectation(description: "testshowUserWithName_success")
        
        // given
        let dataSource = MockHttpRequestManager()
        dataSource.isDetailRequest = true
        provider =  MockDataProvider(mockDataSurce: dataSource)
        provider?.responseType = .success
        viewModel = UsersListViewModel(dataSource: provider!)
        
        guard let viewModel = viewModel else {
            XCTFail("Something went wrong")
            return
        }
        
        //when
        viewModel.showUserWithName(name:"mock1") { result in
            switch result {
            case .success(let user):
                self.responseList = user
                expectation.fulfill()
            case .failure(let error):
                print("Error:\(error.localizedDescription)")
                expectation.fulfill()
            }
        }
        
        //  then
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(self.responseList.count > 0)
    }
    
    func testshowUserWithName_error() throws {
        let expectation = self.expectation(description: "testshowUserWithName_error")
        
        // given
        let dataSource = MockHttpRequestManager()
        dataSource.isDetailRequest = true
        provider =  MockDataProvider(mockDataSurce: dataSource)
        provider?.responseType = .failure
        viewModel = UsersListViewModel(dataSource: provider!)
        var responseError: HttpRequestError = .decoding
        
        guard let viewModel = viewModel else {
            XCTFail("Something went wrong")
            return
        }
        
        //when
        viewModel.showUserWithName(name:"mock1") { result in
            switch result {
            case .success(let detailedUser):
                self.responseList = detailedUser
                expectation.fulfill()
            case .failure(let error):
                print("Error:\(error.localizedDescription)")
                responseError = error as! HttpRequestError
                expectation.fulfill()
            }
        }
        
        // then
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNil(responseList.first?.login)
        XCTAssertTrue(responseError == HttpRequestError.unavailable)
    }
}
