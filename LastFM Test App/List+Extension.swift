//
//  List+Extension.swift
//  LastFM Test App
//
//  Created by Artem Podustov on 6/23/19.
//  Copyright © 2019 podustov. All rights reserved.
//

import Foundation

import Foundation
import ObjectMapper
import RealmSwift

/// Maps object of Realm's List type
func <- <T: Mappable>(left: List<T>, right: Map) {
    var array: [T]?

    if right.mappingType == .toJSON {
        array = Array(left)
    }

    array <- right

    if right.mappingType == .fromJSON {
        if let theArray = array {
            left.append(objectsIn: theArray)
        }
    }
}
