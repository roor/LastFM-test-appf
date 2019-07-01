//
//  LastFM_Test_AppUITests.swift
//  LastFM Test AppUITests
//
//  Created by Artem Podustov on 6/22/19.
//  Copyright © 2019 podustov. All rights reserved.
//

import XCTest

class LastFM_Test_AppUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSearchSegue() {
        let app = XCUIApplication()
        app.navigationBars["Albums"].buttons["Search"].tap()
        let table = app.tables["Empty list"]

        XCTAssertTrue(table.exists)
    }

    func testEditAction() {
        let app = XCUIApplication()
        app.navigationBars["Albums"].buttons["Edit"].tap()
        let doneButton = app.navigationBars["Albums"].buttons["Done"]

        XCTAssertTrue(doneButton.exists)
    }

}
