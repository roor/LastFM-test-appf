//
//  Artist.swift
//  LastFM Test App
//
//  Created by Artem Podustov on 6/22/19.
//  Copyright © 2019 podustov. All rights reserved.
//

import ObjectMapper

final class Artist: Mappable {

    var name: String!
    var mbid: String!
    var listeners: Int?
    var albums: [Album]?

    init?(map: Map) {
        guard let _: String = map["name"].value(),
            let mbid: String = map["mbid"].value(), !mbid.isEmpty else {
            return nil
        }
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        mbid <- map["mbid"]

        var listenersString : String?
        listenersString <- map["listeners"]

        if let listenersString = listenersString, let listeners = Int(listenersString) {
            self.listeners = listeners
        }
    }
    

}
