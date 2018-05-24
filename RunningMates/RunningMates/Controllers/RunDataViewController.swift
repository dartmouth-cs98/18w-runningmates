//
//  RunDataViewController.swift
//  RunningMates
//
//  Created by Divya Kalidindi on 5/21/18.
//  Copyright © 2018 Apple Inc. All rights reserved.
//

import Foundation
import UIKit



class RunDataViewController: UIViewController {
    
 
    @IBOutlet weak var milesPerWeek: UITextField!
    
    @IBOutlet weak var runsPerWeek: UITextField!
    
    @IBOutlet weak var racesDone: UITextView!
    
    @IBOutlet weak var ver1: UIImageView!
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var ver2: UIImageView!
    
    var rootUrl = ""
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var userId: String? = nil
    var userEmail: String? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userId = UserDefaults.standard.string(forKey: "id")!
        self.userEmail = UserDefaults.standard.string(forKey: "email")!
        
        self.hideKeyboardOnBackgroundTap()
        self.userEmail = UserDefaults.standard.value(forKey: "email") as! String
        self.rootUrl = appDelegate.rootUrl
        print("did sign up with strava: ")
        print(self.appDelegate.didSignUpWithStrava)
        if (self.appDelegate.didSignUpWithStrava == 0) {
            self.ver1.isHidden = false
            self.ver2.isHidden = false
        }
        if (self.appDelegate.didSignUpWithStrava == 1) {
            self.ver1.isHidden = true
            self.ver2.isHidden = true
            UserManager.instance.requestUserObject(userEmail: self.userEmail!, completion: {user in
                let data : [String:Any] = user.data!
                self.milesPerWeek.text = String (describing: data["milesPerWeek"])
                self.racesDone.text = data["racesDone"] as! String
                self.runsPerWeek.text = data["runsPerWeek"] as! String
            })
        }
        
        if (UserDefaults.standard.value(forKey: "data") != nil) {
            var defaultData: Data = UserDefaults.standard.value(forKey: "data") as! Data
            var data : [String:Any] = NSKeyedUnarchiver.unarchiveObject(with: defaultData) as! [String:Any]
            
            if (data["milesPerWeek"] != nil) {
                if let mpwkText = (data["milesPerWeek"]! as? String) {
                    self.milesPerWeek.text = mpwkText
                }
            }
            
            if (data["runsPerWeek"] != nil) {
                if let runsperweekText = (data["runsPerWeek"] as? String) {
                    self.runsPerWeek.text = runsperweekText
                }
            }
        }
    }
    
    func updateInfoFromUserDefaults() {
        if (UserDefaults.standard.value(forKey: "data") != nil) {
            var defaultData: Data = UserDefaults.standard.value(forKey: "data") as! Data
            var data : [String:Any] = NSKeyedUnarchiver.unarchiveObject(with: defaultData) as! [String:Any]
            
            let milespwk:Int? = Int(milesPerWeek.text!)
            data["milesPerWeek"] = milespwk
            
            let runsperWk:Int? = Int(runsPerWeek.text!)
            data["runsPerWeek"] = runsperWk
            
            let racesDoneArray:String? = racesDone.text!
            data["racesDone"] = racesDoneArray
            
            let archivedData = NSKeyedArchiver.archivedData(withRootObject: data)
            UserDefaults.standard.set(archivedData, forKey: "data")
        }
    }
        
        
    @IBAction func saveClicked(_ sender: Any) {
        
        //check if enough data has been entered
            updateInfoFromUserDefaults()
            
            let milespwk:Int = Int(milesPerWeek.text!)!
            let runsperWk:Int = Int(runsPerWeek.text!)!
            var elevation: Double = 0.0
            var milesRun: Double = 0.0
            var avgRunLength: Double = 0.0
            
            if (UserDefaults.standard.value(forKey: "data") != nil) {
                var defaultData: Data = (UserDefaults.standard.value(forKey: "data") as? Data)!
                var dataObj : [String:Any] = NSKeyedUnarchiver.unarchiveObject(with: defaultData) as! [String:Any]
                
                if (dataObj["totalElevationClimbed"] as? Double != nil) {
                    elevation = (dataObj["totalElevationClimbed"] as? Double)!
                }
                if (dataObj["totalMilesRun"] as? Double != nil) {
                    milesRun = (dataObj["totalMilesRun"] as? Double)!
                }
                if (dataObj["averageRunLength"] as? Double != nil) {
                    avgRunLength = (dataObj["averageRunLength"] as? Double)!
                }
            }

        
            let data: [String: Any] = [
                "milesPerWeek": milespwk,
                "runsPerWeek": runsperWk,
                "totalElevationClimbed": elevation,
                "totalMilesRun": milesRun,
                "averageRunLength": avgRunLength
            ]
            
            // alamofire request
            let params: [String: Any] = [
                "email": self.userEmail!,
                "data": data
            ]
            
            UserManager.instance.requestUserUpdate(userEmail: self.userEmail!, params: params, completion: {title,message in
                print("updated user here!")
                self.updateInfoFromUserDefaults()
            })
        }
    }
