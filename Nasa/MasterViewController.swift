//
//  MasterViewController.swift
//  Nasa
//
//  Created by Tomas Radvansky on 01/03/2017.
//  Copyright © 2017 Tomas Radvansky. All rights reserved.
//

import UIKit
import MXParallaxHeader
import Async
import MapKit
import RealmSwift

class MasterViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,MXParallaxHeaderDelegate {
    
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet var headerView: UIView!
    
    let minimumHeight:CGFloat = 100.0
    let defaultHeight:CGFloat = 200.0
    
    // Get the default Realm
    let realm = try! Realm()
    var realmNotificationHandler:NotificationToken?
    var meteoriteObjects:Results<MeteoriteObject>?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .lightContent
        self.realmNotificationHandler = realm.addNotificationBlock { notification, realm in
            self.mainTableView.reloadData()
        }
        
        self.meteoriteObjects = realm.objects(MeteoriteObject.self).sorted(byKeyPath: "mass", ascending: false)
        
        // Parallax Header
        mainTableView.parallaxHeader.view = headerView // You can set the parallax header view from the floating view
        mainTableView.parallaxHeader.height = defaultHeight
        mainTableView.parallaxHeader.mode = MXParallaxHeaderMode.fill
        mainTableView.parallaxHeader.minimumHeight = minimumHeight
        
        mainTableView.parallaxHeader.delegate = self
        
        mainTableView.reloadData()
    }
    
    deinit {
        self.realmNotificationHandler?.stop()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let data = self.meteoriteObjects
        {
            return data.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let bCell:MeteoriteCell = tableView.dequeueReusableCell(withIdentifier: "MeteoriteCell", for: indexPath) as! MeteoriteCell
        if let currentMeteorite:MeteoriteObject = self.meteoriteObjects?[indexPath.row]
        {
            bCell.nameLabel.text = currentMeteorite.name
            bCell.classLabel.text = currentMeteorite.recclass
            bCell.massLabel.text = currentMeteorite.mass.weightStyle
            
        }
        return bCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let currentMeteorite:MeteoriteObject = self.meteoriteObjects?[indexPath.row]
        {
            self.performSegue(withIdentifier: "DetailSegue", sender: currentMeteorite)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailSegue"
        {
            if let detailVC = segue.destination as? DetailViewController
            {
                detailVC.currentMeteorite = sender as? MeteoriteObject
            }
        }
    }
    
    // MARK: - MXParallaxHeaderDelegate
    func parallaxHeaderDidScroll(_ parallaxHeader: MXParallaxHeader) {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
        
    }
}
