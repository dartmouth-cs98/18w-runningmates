//
//  EmergencyContactViewController.swift
//  RunningMates
//
//  Created by Divya Kalidindi on 4/25/18.
//  Copyright © 2018 Apple Inc. All rights reserved.
//

import UIKit

class EmergencyContactViewController: UIViewController {
    
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var lastName: UILabel!
    
    @IBOutlet weak var phoneNum: UILabel!
    
    @IBOutlet weak var emailAddr: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle the text field’s user input through delegate callbacks.
    }
    
}
