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
    var provider: ProviderProtocol?

    override func setUpWithError() throws {
        try super.setUpWithError()
        provider = Provider(dataSource: HttpRequestManager())
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        provider = nil
    }

    func testUsersList_success() throws {
        let expectation = self.expectation(description: "getRepositoryList")

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
                XCTAssertTrue(error == .unavailable)
            }
        }

        waitForExpectations(timeout: 20, handler: nil)
    }


}
