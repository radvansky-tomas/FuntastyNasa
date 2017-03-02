//
//  MeteoriteObject.swift
//  Nasa
//
//  Created by Tomas Radvansky on 02/03/2017.
//  Copyright © 2017 Tomas Radvansky. All rights reserved.
//

import Foundation
import AlamofireObjectMapper
import ObjectMapper
import RealmSwift
import Realm

//{
//    "fall": "Fell",
//    "geolocation": {
//        "type": "Point",
//        "coordinates": [
//        6.08333,
//        50.775
//        ]
//    },
//    "id": "1",
//    "mass": "21",
//    "name": "Aachen",
//    "nametype": "Valid",
//    "recclass": "L5",
//    "reclat": "50.775000",
//    "reclong": "6.083330",
//    "year": "1880-01-01T00:00:00.000"
//}


class MeteoriteObject: Object, Mappable {
    dynamic var id:Int = 0
    dynamic var fall:String?
    dynamic var geolocation:GeoLoc?
    dynamic var name:String?
    dynamic var mass:Int = 0
    dynamic var nametype:String?
    dynamic var recclass:String?
    dynamic var reclat:String?
    dynamic var reclong:String?
    dynamic var year:Int = 0

 
    required convenience init?(map: Map) {
        self.init()
    }

    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    let transform = TransformOf<Int, String>(fromJSON: { (value: String?) -> Int? in
        // transform value from String? to Int?
        return Int(value!)
    }, toJSON: { (value: Int?) -> String? in
        // transform value from Int? to String?
        if let value = value {
            return String(value)
        }
        return nil
    })
    
    let yearTransform = TransformOf<Int, String>(fromJSON: { (value: String?) -> Int? in
        // transform value from String? to Int?
        if let strValue = value
        {
            return Int(strValue.substring(to:4))
        }
        return 0
    }, toJSON: { (value: Int?) -> String? in
        // transform value from Int? to String?
        if let value = value {
            return String(value)
        }
        return nil
    })
    
    func mapping(map: Map) {
        id <- (map["id"], transform)
        fall <- map["fall"]
        geolocation <- map["geolocation"]
        name <- map["name"]
        mass <- (map["mass"], transform)
        nametype <- map["nametype"]
        recclass <- map["recclass"]
        reclat <- map["reclat"]
        reclong <- map["reclong"]
        year <- (map["year"], yearTransform)
    }
}

class RealmDouble: Object {
    dynamic var doubleValue:Double = 0.0
}

class GeoLoc: Object,Mappable {
    var type:String?
    
    var coordinates: [Double] {
        get {
            return realmCoordinates.map { $0.doubleValue }
        }
        set {
            realmCoordinates.removeAll()
            realmCoordinates.append(objectsIn: newValue.map({ RealmDouble(value: [$0]) }))
        }
    }
    let realmCoordinates = List<RealmDouble>()
    
    override static func ignoredProperties() -> [String] {
        return ["coordinates"]
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        type <- map["type"]
        coordinates <- map["coordinates"]
    }
}
