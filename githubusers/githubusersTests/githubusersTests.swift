//
//  githubusersTests.swift
//  githubusersTests
//
//  Created by José Marques on 18/04/2021.
//

import XCTest
@testable import githubusers

class githubusersTests: XCTestCase {

    var responseList = [GitHubUser]()
    var userDetail = GitHubUser(login: "",
                                avatarUrl: "",
                                name: "",
                                htmlUrl: "",
                                company: "",
                                publicRepos: 0)
    var provider: DataProviderProtocol?

    override func setUpWithError() throws {
        try super.setUpWithError()
        provider = DataProvider(dataSource: HttpRequestManager())
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        provider = nil
    }

    func testUsersList_success() throws {
        let expectation = self.expectation(description: "getUserList")

        guard let provider = provider else {
            XCTFail("Something went wrong")
            return
        }

        provider.fetchUsersList{ result in
            switch result {
            case .success(let repositories):
                self.responseList = repositories
                expectation.fulfill()
                print(self.responseList)
                XCTAssertTrue(self.responseList.count > 0)
            case .failure(let error):
                print("Error:\(error.localizedDescription)")
                expectation.fulfill()
            }
        }

        waitForExpectations(timeout: 20, handler: nil)
    }

    func testUserDetail_success() throws {
        let expectation = self.expectation(description: "getUserDetail")

        guard let provider = provider else {
            XCTFail("Something went wrong")
            return
        }

        provider.fetchUserDetail(user: "josedesousa7") { result in
            switch result {
            case .success(let userDetail):
                self.userDetail = userDetail
                expectation.fulfill()
                print( self.userDetail)
                XCTAssertNotNil(self.userDetail.login)
            case .failure(let error):
                print("Error:\(error.localizedDescription)")
                expectation.fulfill()
            }
        }

        waitForExpectations(timeout: 20, handler: nil)
    }

    func testUserImage() throws {
        let expectation = self.expectation(description: "testUserImage")

        guard let provider = provider else {
            XCTFail("Something went wrong")
            return
        }
        provider.fetchUserImage(avatarUrl: "https://avatars.githubusercontent.com/u/1?v=4") { result in
            XCTAssertNotNil(result)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 20, handler: nil)
    }

}
