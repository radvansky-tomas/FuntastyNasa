//
//  AppDelegate.swift
//  Nasa
//
//  Created by Tomas Radvansky on 01/03/2017.
//  Copyright © 2017 Tomas Radvansky. All rights reserved.
//

import UIKit
import RealmSwift
import ReachabilitySwift
import SwiftDate


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {
    
    enum UpdateStatus {
        case updated
        case cache
        case realmError
        case apiError
        case noInternet
        case unknownError
    }
    
    var window: UIWindow?
    
    // Get the default Realm
    let realm = try! Realm()
    //declare this property where it won't go out of scope relative to your listener
    let reachability = Reachability()!
    var activatedFromBackground = false
    
    func shouldUpdate()->Bool
    {
        let defaults = UserDefaults.standard
        if let date:Date = defaults.object(forKey: "updatedData") as? Date
        {
            if date.isToday
            {
                return false
            }
        }
        return true
    }
    
    func updateData(completetionHandler: @escaping (_ status:UpdateStatus) -> Void)
    {
        //Check if we need to update today
        if (shouldUpdate())
        {
            //Check if we have internet
            if reachability.isReachable
            {
                NasaClient.loadMeteorites { (data, err) in
                    if let entries = data
                    {
                        do
                        {
                            try self.realm.write {
                                for entry in entries
                                {
                                    self.realm.add(entry, update: true)
                                }
                            }
                            //Update date value
                            let defaults = UserDefaults.standard
                            defaults.set(Date(), forKey: "updatedData")
                            defaults.synchronize()
                            
                            //Updated
                            print("Data Updated!")
                            completetionHandler(.updated)
                        }
                        catch let error as NSError
                        {
                            print(error.localizedDescription)
                            completetionHandler(.realmError)
                        }
                        
                    }
                    else
                    {
                        if err != nil
                        {
                            print(err!.localizedDescription)
                            completetionHandler(.apiError)
                        }
                        else
                        {
                            print("Unknown Error!")
                            completetionHandler(.unknownError)
                        }
                    }
                }
            }
            else
            {
                //Check if we have some cached data
                if realm.objects(MeteoriteObject.self).count > 0
                {
                    print("No Internet Using Cached Data!")
                    completetionHandler(.cache)
                }
                else
                {
                    print("No Internet No Cached Data!")
                    completetionHandler(.noInternet)
                }
                
            }
        }
        else
        {
            print("Using Cached Data!")
            completetionHandler(.cache)
        }
        
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        activatedFromBackground = false
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        //Change VC to splash
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController:SplashViewController = storyboard.instantiateViewController(withIdentifier: "SplashVC") as! SplashViewController
        if let topController = UIApplication.topViewController() {
            topController.present(initialViewController, animated: true, completion: nil)
        }
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        activatedFromBackground = true
    }
    
    func checkStatus()
    {
        updateData { (status:UpdateStatus) in
            switch status
            {
            case .cache, .updated:
                //Change VC
                self.window?.rootViewController?.dismiss(animated: true, completion: nil)
                break
            default:
                let alert:UIAlertController = UIAlertController(title: "Error", message: "Loading error", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { (action:UIAlertAction) in
                    self.checkStatus()
                }))
                
                if let topController = UIApplication.topViewController() {
                    topController.present(alert, animated: true, completion: nil)
                }
                
                break
            }
        }
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        if (self.activatedFromBackground) {
            
        }
        else
        {
            //Change VC to splash
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let initialViewController:SplashViewController = storyboard.instantiateViewController(withIdentifier: "SplashVC") as! SplashViewController
            if let topController = UIApplication.topViewController() {
                topController.present(initialViewController, animated: false, completion: nil)
            }
        }
        checkStatus()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
}

