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
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //https://www.appcoda.com/ios-programming-circular-image-calayer/
        self.profPic.layer.cornerRadius = self.profPic.frame.size.width / 2;
        self.profPic.clipsToBounds = true;
        self.profPic.layer.borderWidth = 1
        self.profPic.layer.borderColor = UIColor(red: 1.0, green: 0.65, blue: 0.35, alpha: 1.0).cgColor

        self.secondView.layer.cornerRadius = secondView.frame.size.height/2
        self.secondView.clipsToBounds = true;
        self.secondView.layer.borderWidth = 4
        self.secondView.layer.borderColor = UIColor(red: 1.0, green: 0.65, blue: 0.35, alpha: 1.0).cgColor


        
        self.settingsButton.layer.cornerRadius = self.settingsButton.frame.size.width / 2;
        self.settingsButton.clipsToBounds = true;
        self.settingsButton.layer.borderColor = UIColor.black.cgColor
        self.settingsButton.layer.borderWidth = 1


        
        self.editButton.layer.cornerRadius = self.editButton.frame.size.width / 2;
        self.editButton.clipsToBounds = true;
               self.editButton.layer.borderColor = UIColor.black.cgColor
        self.editButton.layer.borderWidth = 1
        
        self.safetrackButton.layer.cornerRadius = 10;
        self.safetrackButton.clipsToBounds = true;
        self.safetrackButton.layer.borderColor = UIColor.black.cgColor
        self.safetrackButton.layer.borderWidth = 1


        //TO-DO make this first name
        self.name.text = appDelegate.userEmail
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
  
    
}
