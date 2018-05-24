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
    
//    var dropGender: UIDropDown!

    @IBOutlet weak var dropGender: UIDropDown!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        dropGender = UIDropDown(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
//        dropGender.center = CGPoint(x: self.view.frame.midX, y: self.view.frame.midY)
        dropGender.placeholder = "Select gender..."
        dropGender.options = ["Female", "Male", "Non-Binary"]
        dropGender.didSelect { (option, index) in
            print("You just select: \(option) at index: \(index)")
        }
        self.view.addSubview(dropGender)
        
    }
    
    @IBAction func nextButton(_ sender: Any) {
        print(self.dobPicker.date)
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day,.month,.year], from: self.dobPicker.date);
        print(components.day!)
        print(components.month!)
        print(components.year!)
        
        //send request for DOB as integers
    }
}

