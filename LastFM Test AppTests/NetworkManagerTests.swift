//
//  NetworkManagerTests.swift
//  LastFM Test AppTests
//
//  Created by Artem Podustov on 7/1/19.
//  Copyright © 2019 podustov. All rights reserved.
//

import XCTest
@testable import LastFM_Test_App

class NetworkManagerTests: XCTestCase {


    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSearch() {
        let promise = expectation(description: "not empty list")

        NetworkManager.search(for: "Queen") { (artists) in
            if artists.count > 0 {
                promise.fulfill()
            } else {
                XCTFail("List is empty")
            }
        }
        wait(for: [promise], timeout: 5)
    }

}
