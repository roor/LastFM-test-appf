//
//  NetworkManager.swift
//  LastFM Test App
//
//  Created by Artem Podustov on 6/22/19.
//  Copyright © 2019 podustov. All rights reserved.
//

import Alamofire
import AlamofireObjectMapper

final class NetworkManager {
    static let APIKey = "a401ff83d9458c57fb1aa742ef41435a"

    enum Method: String {
        case artistSearch = "artist.search"
        case artistGetTopAlbums = "artist.getTopAlbums"
        case albumGetInfo = "album.getInfo"
    }

    static func albumInfo(with album: Album, callback: @escaping ([Track]?) -> ()) {
        if let url = prepareURL(for: .albumGetInfo, extraQueryItems: [URLQueryItem(name: "mbid", value: album.mbid)]) {
            Alamofire.request(url).responseArray(keyPath: "album.tracks.track") { (response: DataResponse<[Track]>) in
                response.result.ifSuccess {
                    if let tracks = response.result.value {
                        tracks.forEach({ (track) in
                            album.tracks.append(track)
                        })
                        callback(tracks)
                    } else {
                        callback(nil)
                    }
                }
            }
        }
    }

    static func topAlbums(with artist: Artist, callback: @escaping ([Album]) -> ()) {
        if let url = prepareURL(for: .artistGetTopAlbums, extraQueryItems: [URLQueryItem(name: "mbid", value: artist.mbid)]) {
            Alamofire.request(url).responseArray(keyPath: "topalbums.album") { (response: DataResponse<[Album]>) in
                response.result.ifSuccess {
                    if let list = response.result.value {
                        list.forEach({ (album) in
                            artist.albums.append(album)
                            album.artist = artist
                        })
                        callback(list)
                    } else {
                        callback([Album]())
                    }
                }
            }
        }
    }

    static func search(for artistName: String, callback: @escaping ([Artist]) -> ()) {
        if let url = prepareURL(for: .artistSearch, extraQueryItems: [URLQueryItem(name: "artist", value: artistName)]) {
            Alamofire.request(url).responseArray(keyPath: "results.artistmatches.artist") { (response: DataResponse<[Artist]>) in
                response.result.ifSuccess {
                    if let list = response.result.value {
                        callback(list)
                    } else {
                        callback([Artist]())
                    }
                }
            }
        }
    }

    private static func prepareURL(for method: Method, extraQueryItems: [URLQueryItem]? = nil) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "ws.audioscrobbler.com"
        components.path = "/2.0/"
        var queryItems = [URLQueryItem(name: "method", value: method.rawValue)]

        if let extraQueryItems = extraQueryItems {
            queryItems.append(contentsOf: extraQueryItems)
        }
        queryItems.append(contentsOf: [URLQueryItem(name: "api_key", value: APIKey),
                          URLQueryItem(name: "format", value: "json")])

        components.queryItems = queryItems

        return components.url
    }

}
