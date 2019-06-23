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
    @objc dynamic var mbid: String!
    @objc dynamic var name: String!
    let coverImages = List<CoverImage>()
    let tracks = List<Track>()

    @objc dynamic var isDownloaded: Bool = false 
    @objc dynamic unowned var artist: Artist!
    
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
        if let index = coverImages.firstIndex(where: { $0.imageSize == size }) {
            return coverImages[index].url
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
    @objc dynamic var urlString: String!
    @objc dynamic var imageSizeString: String!
    
    var imageSize: ImageSize {
        return ImageSize(rawValue: imageSizeString) ?? .undefined
    }

    override class func primaryKey() -> String {
        return "urlString"
    }

    override class func ignoredProperties() -> [String] { return ["imageSize"] }

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
        imageSizeString <- map["size"]
    }

}


