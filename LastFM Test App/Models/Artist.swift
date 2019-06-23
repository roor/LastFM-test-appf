//
//  Artist.swift
//  LastFM Test App
//
//  Created by Artem Podustov on 6/22/19.
//  Copyright © 2019 podustov. All rights reserved.
//

import ObjectMapper
import Realm
import RealmSwift

final class Artist: Object, Mappable {

    @objc dynamic var name: String!
    @objc dynamic var mbid: String!
    @objc dynamic var listeners: String?
    let albums = List<Album>()

    required convenience init?(map: Map) {
        self.init()
        guard let _: String = map["name"].value(),
            let mbid: String = map["mbid"].value(), !mbid.isEmpty else {
            return nil
        }
    }

    override class func primaryKey() -> String {
        return "mbid"
    }

    func mapping(map: Map) {
        name <- map["name"]
        mbid <- map["mbid"]
        listeners <- map["listeners"]
    }

}
