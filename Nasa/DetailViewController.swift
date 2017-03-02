//
//  DetailViewController.swift
//  Nasa
//
//  Created by Tomas Radvansky on 02/03/2017.
//  Copyright © 2017 Tomas Radvansky. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import SwiftDate

class DetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var currentMeteorite:MeteoriteObject?
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mainTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.prompt = currentMeteorite?.recclass
        self.navigationItem.title = currentMeteorite?.name
        
        if let tmpObject = self.currentMeteorite
        {
            if let pointsArray = tmpObject.geolocation?.coordinates
            {
                if pointsArray.count >= 2
                {
                    // Drop a pin
                    let dropPin = MKPointAnnotation()
                    let coord:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: pointsArray[1], longitude: pointsArray[0])
                    dropPin.coordinate = coord
                    dropPin.title = tmpObject.name
                    mapView.addAnnotation(dropPin)
                    mapView.setCenter(coord, animated: true)
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if currentMeteorite != nil
        {
            return 6
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let metadataCell:MetadataCell = tableView.dequeueReusableCell(withIdentifier: "MetadataCell", for: indexPath) as! MetadataCell
        if let tmpObject = self.currentMeteorite
        {
            switch indexPath.row {
            case 0:
                metadataCell.keyLabel.text = "Location"
                if let pointsArray = tmpObject.geolocation?.coordinates
                {
                    if pointsArray.count >= 2
                    {
                        metadataCell.valueLabel.text = "\(pointsArray[0])°, \(pointsArray[0])°"
                        break
                    }
                }
                metadataCell.valueLabel.text = "Unknown"
                break
            case 1:
                metadataCell.keyLabel.text = "ID"
                metadataCell.valueLabel.text = "\(tmpObject.id)"
                break
            case 2:
                metadataCell.keyLabel.text = "Nametype"
                metadataCell.valueLabel.text = tmpObject.nametype
                break
            case 3:
                metadataCell.keyLabel.text = "Mass"
                metadataCell.valueLabel.text = tmpObject.mass.weightStyle
                break
            case 4:
                metadataCell.keyLabel.text = "Fall"
                metadataCell.valueLabel.text = tmpObject.fall
                break
            case 5:
                metadataCell.keyLabel.text = "Year"
                metadataCell.valueLabel.text = "\(tmpObject.year)"
                break
            default:
                metadataCell.keyLabel.text = ""
                metadataCell.valueLabel.text = ""
            }
        }
        return metadataCell
    }
    
}
