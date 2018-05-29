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
import EMAlertController

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
    
    var firstBool = false
    var lastBool = false
    var genderBool = false
    var dob = true
    var ageVal: Int = 0
    
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
            self.genderBool = true
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
        
        let now = Date()
        let birthday = self.dobPicker.date
        
        //https://stackoverflow.com/questions/25232009/calculate-age-from-birth-date-using-nsdatecomponents-in-swift
        let ageComponents = calendar.dateComponents([.year], from: birthday, to: now)
        let age = ageComponents.year!
        print("AGE\n\n")
        self.ageVal = age   
        
        
        //check if enough data has been entered
        if (firstName.text! != "") {
            self.firstBool = true
        }
        if (lastName.text! != "") {
            self.lastBool = true
        }
        if (self.gender != nil) {
            self.genderBool = true
        }
        if (self.ageVal < 18) {
            let alert = EMAlertController(title: "Uh oh!", message: "You must be 18 years or older to join RunningMates.")
            let cancel = EMAlertAction(title: "Okay", style: .cancel)
            alert.addAction(action: cancel)
            self.present(alert, animated: true, completion: nil)
        }
        
        if (self.firstBool == false || self.lastBool == false || self.genderBool == false)  {
            let alert = EMAlertController(title: "", message: "Please fill in all required fields.")
            let cancel = EMAlertAction(title: "Okay", style: .cancel)
            alert.addAction(action: cancel)
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
                "birthYear": components.year!,
                "age": self.ageVal
            ]
            
            UserManager.instance.requestUserUpdate(userEmail: self.userEmail!, params: params, completion: {title,message in
                print("updated user here!")
                self.updateInfoFromUserDefaults()
                UserDefaults.standard.set(self.ageVal, forKey: "age")
            })
        }
        
        //send request for DOB as integers
    }
}

