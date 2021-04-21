//
//  UserTableViewCellViewModelTests.swift
//  githubusersTests
//
//  Created by José Marques on 21/04/2021.
//  Copyright © 2021 José Marques. All rights reserved.
//

import XCTest
@testable import githubusers

class UserTableViewCellViewModelTests: XCTestCase {
    
    var provider: MockDataProvider!
    var viewModel: UserTableViewCellViewModel!
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
    
    func testshowUserImage_success() throws {
        let expectation = self.expectation(description: "testshowUserImage_success")
        
        // given
        provider?.responseType = .success
        let user = GitHubUser(login: "userLogin",
                              avatarUrl: "userAvatarUrl",
                              name: "userName",
                              htmlUrl: "userHtmlUrl",
                              company: "userCompany",
                              publicRepos: 0)
        viewModel = UserTableViewCellViewModel(model: user, dataSource: provider)
        var image: UIImage!
        
        guard let viewModel = viewModel else {
            XCTFail("Something went wrong")
            return
        }
        
        //when
        viewModel.showUserImage { result in
            image = result
            expectation.fulfill()
        }
        
        //  then
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNotNil(image)
    }
    
    func testshowUserImage_error() throws {
        let expectation = self.expectation(description: "testshowUserImage_success")
        
        // given
        provider?.responseType = .failure
        let user = GitHubUser(login: "userLogin",
                              avatarUrl: "userAvatarUrl",
                              name: "userName",
                              htmlUrl: "userHtmlUrl",
                              company: "userCompany",
                              publicRepos: 0)
        viewModel = UserTableViewCellViewModel(model: user, dataSource: provider)
        var image: UIImage!
        
        guard let viewModel = viewModel else {
            XCTFail("Something went wrong")
            return
        }
        
        //when
        viewModel.showUserImage { result in
            image = result
            expectation.fulfill()
        }
        
        //  then
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNotNil(image)
    }
}
