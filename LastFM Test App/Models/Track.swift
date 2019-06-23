//
//  Track.swift
//  LastFM Test App
//
//  Created by Artem Podustov on 6/22/19.
//  Copyright © 2019 podustov. All rights reserved.
//

import ObjectMapper

final class Track: Mappable {

    var name: String!

    init?(map: Map) {

        guard let _: String = map["name"].value() else {
            return nil
        }
    }

    func mapping(map: Map) {
        name <- map["name"]
    }
}
