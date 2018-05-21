//
//  BasicInfoViewController.swift
//  RunningMates
//
//  Created by Divya Kalidindi on 5/21/18.
//  Copyright © 2018 Apple Inc. All rights reserved.
//

import Foundation
import UIKit
import UIDropDown


class BasicInfoViewController: UIViewController {
    
    @IBOutlet weak var firstName: UITextField!
    
    @IBOutlet weak var lastName: UITextField!
    
    
    
    @IBOutlet weak var dobPicker: UIDatePicker!
    var drop: UIDropDown!
    
    
    
    var genderPickerOptions: [String] = [String]()
    var imagePicker: UIImagePickerController = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        drop = UIDropDown(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        drop.center = CGPoint(x: self.view.frame.midX, y: self.view.frame.midY)
        drop.placeholder = "Select gender..."
        drop.options = ["Female", "Male", "Non-Binary"]
        drop.didSelect { (option, index) in
            print("You just select: \(option) at index: \(index)")
        }
        self.view.addSubview(drop)
    }
}

