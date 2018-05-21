//
//  SettingsViewController.swift
//  RunningMates
//
//  Created by Sara Topic on 24/02/2018.
//  Copyright © 2018 Apple Inc. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var privacyButton: UIButton!
    @IBOutlet weak var notificationButton: UIButton!
    @IBOutlet weak var termsButton: UIButton!
    @IBOutlet weak var communityButton: UIButton!
    @IBOutlet weak var safetyButton: UIButton!
    @IBOutlet weak var creditButton: UIButton!
    
    @IBOutlet weak var signOutButton: UIButton!
    //  @IBOutlet weak var genderLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // learned to add border stuff here: https://stackoverflow.com/questions/37230084/how-to-change-uibutton-border-color-black-to-white
        
        self.privacyButton.layer.borderWidth = 3.0;
        self.privacyButton.layer.borderColor = UIColor.darkGray.cgColor;
        
        self.notificationButton.layer.borderWidth = 3.0;
        self.notificationButton.layer.borderColor = UIColor.darkGray.cgColor;
        
        self.termsButton.layer.borderWidth = 3.0;
        self.termsButton.layer.borderColor = UIColor.darkGray.cgColor;
        
        self.communityButton.layer.borderWidth = 3.0;
        self.communityButton.layer.borderColor = UIColor.darkGray.cgColor;
        
        self.safetyButton.layer.borderWidth = 3.0;
        self.safetyButton.layer.borderColor = UIColor.darkGray.cgColor;
        
        self.creditButton.layer.borderWidth = 3.0;
        self.creditButton.layer.borderColor = UIColor.darkGray.cgColor;
        
        self.signOutButton.layer.borderWidth = 3.0;
        self.signOutButton.layer.borderColor = UIColor.darkGray.cgColor;
        self.signOutButton.layer.cornerRadius = 5

        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func signOutPressed(_ sender: Any) {
        UserManager.instance.requestForSignOut(completion: {
            let  mainVC : ViewController = self.storyboard?.instantiateViewController(withIdentifier: "Main") as! ViewController
            self.present(mainVC, animated: true, completion: nil)
        })
    }
    
}

