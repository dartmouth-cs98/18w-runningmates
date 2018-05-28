//
//  SettingsViewController.swift
//  RunningMates
//
//  Created by Sara Topic on 24/02/2018.
//  Copyright © 2018 Apple Inc. All rights reserved.
//

import UIKit
import MessageUI

class SettingsViewController: UIViewController, MFMailComposeViewControllerDelegate  {
    
    // MARK: Properties
//
    @IBOutlet weak var ecButton: UIButton!
    @IBOutlet weak var faqButton: UIButton!
    @IBOutlet weak var contactButton: UIButton!
    @IBOutlet weak var tosButton: UIButton!
    @IBOutlet weak var ppButton: UIButton!
    @IBOutlet weak var signoutButton: UIButton!
    //    @IBOutlet weak var privacyButton: UIButton!
//    @IBOutlet weak var notificationButton: UIButton!
//    @IBOutlet weak var termsButton: UIButton!
//    @IBOutlet weak var communityButton: UIButton!
//    @IBOutlet weak var safetyButton: UIButton!
//    @IBOutlet weak var creditButton: UIButton!
//
//    @IBOutlet weak var signOutButton: UIButton!
//    //  @IBOutlet weak var genderLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // learned to add border stuff here: https://stackoverflow.com/questions/37230084/how-to-change-uibutton-border-color-black-to-white
        self.ecButton.layer.cornerRadius = 16
        self.faqButton.layer.cornerRadius = 16
        self.contactButton.layer.cornerRadius = 16
        self.tosButton.layer.cornerRadius = 16
        self.ppButton.layer.cornerRadius = 16
        self.signoutButton.layer.cornerRadius = 5
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func sendMail(_ sender: Any) {
        let email = "foo@bar.com"
        if let url = NSURL(string: "mailto:\(email)") {
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }

    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
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

