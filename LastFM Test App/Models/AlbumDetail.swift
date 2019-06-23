//
//  AlbumDetail.swift
//  LastFM Test App
//
//  Created by Artem Podustov on 6/22/19.
//  Copyright © 2019 podustov. All rights reserved.
//

import ObjectMapper

final class AlbumDetail: Mappable {
    var tracks: [Track]!

    init?(map: Map) {
        if let tracks = map["tracks.track"].currentValue as? [Any], tracks.isEmpty {
            return nil
        }
    }

    func mapping(map: Map) {
        tracks <- map["tracks.track"]
    }
}
