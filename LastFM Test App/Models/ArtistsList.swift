//
//  ArtistsList.swift
//  LastFM Test App
//
//  Created by Artem Podustov on 6/22/19.
//  Copyright © 2019 podustov. All rights reserved.
//

import ObjectMapper

final class ArtistsList: Mappable {

    // total records
    var total: Int!
    var artists: [Artist]!

    init?(map: Map) {
        guard map["artistmatches"].isKeyPresent else {
            return nil
        }
    }

    func mapping(map: Map) {
        var stringTotal : String!
        stringTotal <- map["opensearch:totalResults"]
        total = Int(stringTotal)!

        artists <- map["artistmatches.artist"]
    }
}
