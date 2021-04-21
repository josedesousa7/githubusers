//
//  DataProviderTests.swift
//  githubusersTests
//
//  Created by José Marques on 20/04/2021.
//  Copyright © 2021 José Marques. All rights reserved.
//

import XCTest
@testable import githubusers

class DataProviderTests: XCTestCase {

    var provider: DataProviderProtocol?
    var dataSource: MockHttpRequestManager?
    var responseList = [GitHubUser]()

    override func setUpWithError() throws {
       try super.setUpWithError()
        dataSource = MockHttpRequestManager()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        provider = nil
        dataSource = nil
        responseList.removeAll()
    }

    func testfetchUsersList_success() throws {
        let expectation = self.expectation(description: "testfetchUsersList_success")

        // given
        dataSource?.responseType = .success
        provider = DataProvider(dataSource: dataSource!)

        guard let provider = provider else {
            XCTFail("Something went wrong")
            return
        }

        //when
        provider.fetchUsersList { result in
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

    func testfetchUsersList_error() throws {
        let expectation = self.expectation(description: "testfetchUsersList_error")

        // given
        dataSource?.responseType = .failure
        provider = DataProvider(dataSource: dataSource!)
        var responseError: HttpRequestError = .decoding

        guard let provider = provider else {
            XCTFail("Something went wrong")
            return
        }

        //when
        provider.fetchUsersList { result in
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

    func testfetchUsersDetail_success() throws {
        let expectation = self.expectation(description: "testfetchUsersDetail_success")

        // given
        dataSource?.responseType = .success
        dataSource?.isDetailRequest = true
        provider = DataProvider(dataSource: dataSource!)
        var user: GitHubUser!

        guard let provider = provider else {
            XCTFail("Something went wrong")
            return
        }

        //when
        provider.fetchUserDetail(user: "mock1") { result in
            switch result {
            case .success(let detailedUser):
                user = detailedUser
                expectation.fulfill()
            case .failure(let error):
                print("Error:\(error.localizedDescription)")
                expectation.fulfill()
            }
        }

        //  then
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(user.login, "mock1")
    }

    func testfetchUsersDetail_error() throws {
        let expectation = self.expectation(description: "testfetchUsersDetail_error")

        // given
        dataSource?.responseType = .failure
        dataSource?.isDetailRequest = true
        var responseError: HttpRequestError = .decoding
        provider = DataProvider(dataSource: dataSource!)
        var user: GitHubUser?

        guard let provider = provider else {
            XCTFail("Something went wrong")
            return
        }

        //when
        provider.fetchUserDetail(user: "mock1") { result in
            switch result {
            case .success(let detailedUser):
                user = detailedUser
                expectation.fulfill()
            case .failure(let error):
                print("Error:\(error.localizedDescription)")
                responseError = error as! HttpRequestError
                expectation.fulfill()
            }
        }

        // then
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNil(user?.login)
        XCTAssertTrue(responseError == HttpRequestError.unavailable)
    }

    func testfetchUsersImage_success() throws {
        let expectation = self.expectation(description: "testfetchUsersImage_success")

        // given
        dataSource?.responseType = .success
        provider = DataProvider(dataSource: dataSource!)
        var userImage: UIImage!

        guard let provider = provider else {
            XCTFail("Something went wrong")
            return
        }

        //when
        provider.fetchUserImage(avatarUrl: "") { result in
            userImage = result
            expectation.fulfill()
        }

        // then
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNotNil(userImage)
    }
}
