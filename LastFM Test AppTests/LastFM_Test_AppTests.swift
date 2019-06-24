//
//  LastFM_Test_AppTests.swift
//  LastFM Test AppTests
//
//  Created by Artem Podustov on 6/22/19.
//  Copyright © 2019 podustov. All rights reserved.
//

import XCTest
@testable import LastFM_Test_App

class LastFM_Test_AppTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test30sDurationConverter() {
        let timeDuration: TimeInterval = 30
        let time = timeDuration.time()
        XCTAssertEqual(time, "0:30")
    }

    func testNegative30DurationConverter() {
        let timeDuration: TimeInterval = -30
        let time = timeDuration.time()
        XCTAssertEqual(time, "0:30")
    }

    func testAlbumDetailSegue() {
        XCTAssertEqual(Segue.DetailSegue, "detailSegue")
    }

    func testAlbumsSegue() {
        XCTAssertEqual(Segue.AlbumsSegue, "albumsSegue")
    }

    func testSearchSegue() {
        XCTAssertEqual(Segue.SearchSegue, "searchSegue")
    }
    
}
