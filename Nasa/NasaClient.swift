//
//  NasaClient.swift
//  Nasa
//
//  Created by Tomas Radvansky on 02/03/2017.
//  Copyright © 2017 Tomas Radvansky. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

let appToken = "7uSPOtwxAsgjKjGP2JBzv7xac"

class NasaClient: NSObject {
    
    class func loadMeteorites(completetionHandler: @escaping (_ data:[MeteoriteObject]?, _ error:Error?) -> Void) {
        let headers: HTTPHeaders = [
            "X-App-Token": appToken
        ]
        
        //Possibility to download sorted list
        //let parameters: Parameters = ["order": "mass"]
        
        Alamofire.request("https://data.nasa.gov/resource/y77d-th95.json", headers: headers).responseArray { (response: DataResponse<[MeteoriteObject]>) in
            
            completetionHandler(response.result.value,response.error)
        }
        
    }
    
}
