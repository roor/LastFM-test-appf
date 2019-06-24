//
//  TrackTests.swift
//  LastFM Test AppTests
//
//  Created by Artem Podustov on 6/24/19.
//  Copyright © 2019 podustov. All rights reserved.
//

import XCTest
import ObjectMapper

@testable import LastFM_Test_App

class TrackTests: XCTestCase {

    let trackName = "Test Track"
    let url = "https://someurl.com"
    let duration = "120"

    var track: Track?

    override func setUp() {
        let json = [
            "name": trackName
            , "url": url
            , "duration": duration
        ]

        track = Track(JSON: json)
    }

    override func tearDown() {
        track = nil
    }

    func testTrackName() {
        XCTAssertEqual(track?.name, trackName)
    }

    func testTrackURL() {
        XCTAssertEqual(track?.url, url)
    }

    func testTrackDuration() {
        XCTAssertEqual(track?.duration, 120)
    }

    func testTrackWrongNameKey() {
        let json = [
            "WrongKeyName": ""
            , "url": "url"
            , "duration": "duration"
        ]

        let track = Track(JSON: json)
        XCTAssertNil(track, "With wrong name key track shouldn't be created")
    }

    func testTrackWrongURLKey() {
        let json = [
            "name": ""
            , "wrongKeyURL": "url"
            , "duration": "duration"
        ]

        let track = Track(JSON: json)
        XCTAssertNil(track, "With wrong url key track shouldn't be created")
    }

    func testTrackURLIsNil() {
        let json = [
            "name": ""
            , "url": nil
            , "duration": "duration"
        ]

        let track = Track(JSON: json)
        XCTAssertNil(track, "url shouldn't be nil")
    }

    func testTrackDurationIsNil() {
        let json = [
            "name": ""
            , "url": "url"
            , "duration": nil
        ]

        let track = Track(JSON: json)
        XCTAssertNotNil(track, "With nil duration, track still should be created")
    }

}
