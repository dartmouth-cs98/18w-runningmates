//
//  ProfPrefViewController.swift
//  RunningMates
//
//  Created by Divya Kalidindi on 5/26/18.
//  Copyright © 2018 Apple Inc. All rights reserved.
//

import Foundation
import UIKit
import OAuthSwift
import Alamofire
import WebKit
import os.log

class ProfPrefViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UINavigationControllerDelegate {

    
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
        self.userId = UserDefaults.standard.string(forKey: "id")!
        self.userEmail = UserDefaults.standard.string(forKey: "email")!
        self.bioTextView.layer.borderWidth = 1
        self.bioTextView.layer.borderColor = UIColor.gray.cgColor
        
        self.hideKeyboardOnBackgroundTap()
        self.userEmail = UserDefaults.standard.value(forKey: "email") as! String
        self.rootUrl = appDelegate.rootUrl
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        pickerOptions = ["Casual running partners", "Training buddy", "Up for anything", "Meet new friends", "More than friends"]
        
    }
    
    func updateInfoFromUserDefaults() {
        UserDefaults.standard.set(bioTextView.text, forKey: "bio")
    }
    // The number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerOptions.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) ->
        String? {
            return pickerOptions[row]
    }
    
    
    @IBAction func saveClick(_ sender: Any) {
        // https://stackoverflow.com/questions/26674399/getting-selected-value-of-a-uipickerviewcontrol-in-swift
        let selectedValue = pickerOptions[pickerView.selectedRow(inComponent: 0)]
//        if (bioTextView.text! == "") {
//            let alert = UIAlertController(title: "", message: "Please fill in all required fields to create a new profile.", preferredStyle: UIAlertControllerStyle.alert)
//            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//        }
            updateInfoFromUserDefaults()

            // alamofire request
            let params: [String: Any] = [
                "email": self.userEmail!,
                "bio": self.bioTextView.text!,
                "desiredGoals": [selectedValue]
                ]

            UserManager.instance.requestUserUpdate(userEmail: self.userEmail!, params: params, completion: {title,message in
                self.updateInfoFromUserDefaults()
                UserDefaults.standard.set([selectedValue], forKey: "desiredGoals")
                

                let  vc = self.storyboard?.instantiateViewController(withIdentifier: "Filter") as! FilterViewController

                let matchVc = self.storyboard?.instantiateViewController(withIdentifier: "Matching") as! UINavigationController
                // matchVc.present(vc, animated: true)
                self.show(matchVc, sender: nil )
                matchVc.present(vc, animated: true, completion: nil)



//                self.present(vc, animated: true, completion: nil)
                
//                let storyboard : UIStoryboard = UIStoryboard(name: "Filter", bundle: nil)
//                let vc : FilterViewController = storyboard.instantiateViewController(withIdentifier: "filterView") as! FilterViewController
                /// vc.teststring = "hello"
                
//                let navigationController = UINavigationController(rootViewController: vc)
//
//                self.present(navigationController, animated: true, completion: nil)
            })
        

//            let isPresentingInAddContactMode = presentingViewController is UINavigationController
//
//            if isPresentingInAddContactMode {
//                dismiss(animated: true, completion: nil)
//            }
//            else if let owningNavigationController = navigationController{
//                owningNavigationController.popViewController(animated: true)
//            }
//            else {
//                fatalError("editing profile error.")
//            }


        /// vc.teststring = "hello"
        
        
    }
}
