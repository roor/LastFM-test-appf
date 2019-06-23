//
//  Track.swift
//  LastFM Test App
//
//  Created by Artem Podustov on 6/22/19.
//  Copyright © 2019 podustov. All rights reserved.
//

import ObjectMapper
import Realm
import RealmSwift

final class Track: Object, Mappable {

    dynamic var name: String!
    dynamic var url: String!

    /**
     Track duration in seconds.
     */
    dynamic var duration: TimeInterval = 0

    required convenience init?(map: Map) {
        self.init()

        guard let _: String = map["name"].value(), let _: String = map["url"].value() else {
            return nil
        }
    }

    func mapping(map: Map) {
        name <- map["name"]
        url <- map["url"]

        var durationString: String?
        durationString <- map["duration"]
        if let durationString = durationString, let interval = TimeInterval(durationString) {
            duration = interval
        }
    }
}
