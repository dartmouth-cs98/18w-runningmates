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
    var rootUrl = ""
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var userId: String? = nil
    var userEmail: String? = nil
    var gender: String? = nil
    
    var newUser: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userId = UserDefaults.standard.string(forKey: "id")!
        self.userEmail = UserDefaults.standard.string(forKey: "email")!
        
        self.hideKeyboardOnBackgroundTap()
        self.userEmail = UserDefaults.standard.value(forKey: "email") as! String
        self.rootUrl = appDelegate.rootUrl

//        dropGender = UIDropDown(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
//        dropGender.center = CGPoint(x: self.view.frame.midX, y: self.view.frame.midY)
        dropGender.placeholder = "Select gender..."
        dropGender.options = ["Female", "Male", "Non-Binary"]
        dropGender.didSelect { (option, index) in
            print("You just select: \(option) at index: \(index)")
            self.gender = option
        }
        self.view.addSubview(dropGender)
        
    }
    
    func updateInfoFromUserDefaults() {

        UserDefaults.standard.set(firstName.text, forKey: "firstName")
        UserDefaults.standard.set(self.gender, forKey: "gender")
        
    }
    
    @IBAction func nextButton(_ sender: Any) {
        print("GENDER\n", self.gender)
        print(self.dobPicker.date)
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day,.month,.year], from: self.dobPicker.date);
        print(components.day!)
        print(components.month!)
        print(components.year!)
        
        //check if enough data has been entered
        if (firstName.text! == "")  {
            let alert = UIAlertController(title: "", message: "Please fill in all required fields to create a new profile.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            updateInfoFromUserDefaults()
            // alamofire request
            let params: [String: Any] = [
                "email": self.userEmail!,
                "firstName": self.firstName.text!,
                "gender": self.gender!,
                "birthMonth": components.month!,
                "birthDay": components.day!,
                "birthYear": components.year!
            ]
            
            UserManager.instance.requestUserUpdate(userEmail: self.userEmail!, params: params, completion: {title,message in
                print("updated user here!")
                self.updateInfoFromUserDefaults()
            })
            
        }
        
        //send request for DOB as integers
    }
}

