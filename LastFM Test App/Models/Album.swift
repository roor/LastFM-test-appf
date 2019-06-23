//
//  Album.swift
//  LastFM Test App
//
//  Created by Artem Podustov on 6/22/19.
//  Copyright © 2019 podustov. All rights reserved.
//

import ObjectMapper

final class Album: Mappable {
    var mbid: String!
    var name: String!
    var coverImages: [CoverImage]?

    var isSelected: Bool = false

    unowned var artist: Artist!
    var albumDetail: AlbumDetail?
    
    init?(map: Map) {
        guard let _: String = map["name"].value(),
            let mbid: String = map["mbid"].value(), !mbid.isEmpty else {
                return nil
        }
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

final class CoverImage: Mappable {
    var url: URL!
    var imageSize: ImageSize!

    init?(map: Map) {
        guard let urlString: String = map["#text"].value(), let _ = URL(string: urlString) else {
            return nil
        }
    }

    func mapping(map: Map) {
        var urlString: String!
        urlString <- map["#text"]
        url = URL(string: urlString)

        var imageSizeString: String!
        imageSizeString <- map["size"]

        imageSize = ImageSize(rawValue: imageSizeString) ?? .undefined
    }

}


