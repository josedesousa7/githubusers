//
//  UserDetailViewModelTests.swift
//  githubusersTests
//
//  Created by José Marques on 21/04/2021.
//  Copyright © 2021 José Marques. All rights reserved.
//

import XCTest
@testable import githubusers

class UserDetailViewModelTests: XCTestCase {
    
    var provider: MockDataProvider!
    var viewModel: UserDetailViewModel!
    var user: GitHubUser!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        provider = MockDataProvider(mockDataSurce: MockHttpRequestManager())
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        provider = nil
        viewModel = nil
        user = nil
    }
    
    func testshowUserDetail_success() throws {
        let expectation = self.expectation(description: "testshowUserDetail_success")
        
        // given
        let dataSource = MockHttpRequestManager()
        dataSource.isDetailRequest = true
        provider =  MockDataProvider(mockDataSurce: dataSource)
        provider?.responseType = .success
        viewModel = UserDetailViewModel(dataSource: provider!)
        
        guard let viewModel = viewModel else {
            XCTFail("Something went wrong")
            return
        }
        
        //when
        viewModel.showUserWithName(name:"mock1") { result in
            switch result {
            case .success(let user):
                self.user = user
                expectation.fulfill()
            case .failure(let error):
                print("Error:\(error.localizedDescription)")
                expectation.fulfill()
            }
        }
        
        //  then
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(self.user.name, "mock1_name")
    }
    
    func testshowUserDetail_error() throws {
        let expectation = self.expectation(description: "testshowUserDetail_error")
        
        // given
        let dataSource = MockHttpRequestManager()
        dataSource.isDetailRequest = true
        provider =  MockDataProvider(mockDataSurce: dataSource)
        provider?.responseType = .failure
        viewModel = UserDetailViewModel(dataSource: provider!)
        var responseError: HttpRequestError = .decoding
        
        guard let viewModel = viewModel else {
            XCTFail("Something went wrong")
            return
        }
        
        //when
        viewModel.showUserWithName(name:"mock1") { result in
            switch result {
            case .success(let user):
                self.user = user
                expectation.fulfill()
            case .failure(let error):
                print("Error:\(error.localizedDescription)")
                responseError = error as! HttpRequestError
                expectation.fulfill()
            }
        }
        
        //  then
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNil(self.user?.name)
        XCTAssertTrue(responseError == HttpRequestError.unavailable)
    }
    
    func testshowUserImage_success() throws {
        let expectation = self.expectation(description: "testshowUserImage_success")
        
        // given
        provider?.responseType = .success
        viewModel = UserDetailViewModel(dataSource: provider!)
        let user = GitHubUser(login: "userLogin",
                              avatarUrl: "userAvatarUrl",
                              name: "userName",
                              htmlUrl: "userHtmlUrl",
                              company: "userCompany",
                              publicRepos: 0)
        var image: UIImage!
        
        guard let viewModel = viewModel else {
            XCTFail("Something went wrong")
            return
        }
        
        //when
        viewModel.showUserImage(user: user) { result in
            image = result
            expectation.fulfill()
        }
        
        //  then
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNotNil(image)
    }
}
