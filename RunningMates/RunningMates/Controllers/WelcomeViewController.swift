//
//  WelcomeVC.swift
//  RunningMates
//
//  Created by Sara Topic on 28/05/2018.
//  Copyright © 2018 Apple Inc. All rights reserved.
//

//
//  ProfPrefViewController.swift
//  RunningMates
//
//  Created by Divya Kalidindi on 5/26/18.
//  Copyright © 2018 Apple Inc. All rights reserved.
//

import Foundation
import UIKit

class WelcomeViewController: UIViewController {
    
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var bioTextView: UITextView!
    
    var rootUrl = ""
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var userId: String? = nil
    var userEmail: String? = nil
    var pickerOptions: [String] = [String]()
    var newUser: User!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    

    
    @IBAction func saveClick(_ sender: Any) {

        self.appDelegate.userEmail = self.emailTextField.text!
        let storyboard : UIStoryboard = UIStoryboard(name: "ProfPic", bundle: nil)
        let vc : ProfPic = storyboard.instantiateViewController(withIdentifier: "profPic") as! ProfPic
        /// vc.teststring = "hello"
        
        let navigationController = UINavigationController(rootViewController: vc)
        
        self.present(navigationController, animated: true, completion: nil)
    }
}

