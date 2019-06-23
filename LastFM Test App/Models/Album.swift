//
//  Album.swift
//  LastFM Test App
//
//  Created by Artem Podustov on 6/22/19.
//  Copyright © 2019 podustov. All rights reserved.
//

import ObjectMapper
import Realm
import RealmSwift

final class Album: Object, Mappable {
    dynamic var mbid: String!
    dynamic var name: String!
    dynamic var coverImages: [CoverImage]?
    let tracks = List<Track>()

    /**
     Used in cell pre selection for downloads.
     */
    dynamic var isSelected: Bool = false
    dynamic var isDownloaded: Bool = false
    dynamic unowned var artist: Artist!
    
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
        coverImages <- map["image"]
    }

    func coverImageURL(with size: ImageSize) -> URL? {
        if let images = coverImages {
            if let index = images.firstIndex(where: { $0.imageSize == size }) {
                return images[index].url
            }
        }

        return nil
    }

}

enum ImageSize: String {
    case undefined = "undefined"
    case small = "small"
    case medium = "medium"
    case large = "large"
    case extraLarge = "extralarge"
}

final class CoverImage: Object, Mappable {
    dynamic var urlString: String!
    dynamic var imageSize: ImageSize!

    override class func primaryKey() -> String {
        return "urlString"
    }

    var url: URL? {
        return URL(string: urlString)
    }

    required convenience init?(map: Map) {
        self.init()
        guard let urlString: String = map["#text"].value(), let _ = URL(string: urlString) else {
            return nil
        }
    }

    func mapping(map: Map) {
        urlString <- map["#text"]

        var imageSizeString: String!
        imageSizeString <- map["size"]

        imageSize = ImageSize(rawValue: imageSizeString) ?? .undefined
    }

}


