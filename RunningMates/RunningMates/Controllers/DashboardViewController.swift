//
//  DashboardViewController.swift
//  RunningMates
//
//  Created by Sara Topic on 26/04/2018.
//  Copyright © 2018 Apple Inc. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {
    
    // MARK: Properties
    

    @IBOutlet weak var secondView: UIImageView!
    @IBOutlet weak var profPic: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var safetrackButton: UIButton!
    
    @IBOutlet weak var metricCirc2: UIView!
    @IBOutlet weak var metricCirc: UIView!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var runsWkLabel: UILabel!
    @IBOutlet weak var milesWkLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //https://www.appcoda.com/ios-programming-circular-image-calayer/
        self.profPic.layer.cornerRadius = self.profPic.frame.size.width / 2;
        self.profPic.clipsToBounds = true;
        self.profPic.layer.borderWidth = 2.5;
        self.profPic.layer.borderColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).cgColor
        
        self.metricCirc.layer.cornerRadius = self.metricCirc.frame.size.width / 2;
        self.metricCirc.clipsToBounds = true;
        self.metricCirc.layer.borderWidth = 1.5;
        self.metricCirc.layer.borderColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).cgColor
        
        self.metricCirc2.layer.cornerRadius = self.metricCirc2.frame.size.width / 2;
        self.metricCirc2.clipsToBounds = true;
        self.metricCirc2.layer.borderWidth = 1.5;
        self.metricCirc2.layer.borderColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).cgColor
        
        self.name.text = UserDefaults.standard.string(forKey: "firstName")!
        
        var data: [String: Any] = UserDefaults.standard.value(forKey: "data") as! [String : Any]
        self.milesWkLabel.text = String(describing: data["milesPerWeek"]!)
        self.runsWkLabel.text = String(describing: data["runsPerWeek"]!)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.name.text = UserDefaults.standard.string(forKey: "firstName")!
        var data: [String: Any] = UserDefaults.standard.value(forKey: "data") as! [String : Any]
        self.milesWkLabel.text = String(describing: data["milesPerWeek"]!)
        self.runsWkLabel.text = String(describing: data["runsPerWeek"]!)
    }
    
}
