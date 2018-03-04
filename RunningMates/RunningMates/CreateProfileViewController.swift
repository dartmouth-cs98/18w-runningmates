//
//  CreateProfileViewController.swift
//  RunningMates
//
//  Created by dali on 3/1/18.
//  Copyright © 2018 Apple Inc. All rights reserved.
//

import UIKit
import OAuthSwift
import Alamofire
import WebKit

class CreateProfileViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var bioTextView: UITextField!
    @IBOutlet weak var nameTextView: UITextField!
    @IBOutlet weak var locationTextView: UITextField!
    //var rootURl: String = "https://running-mates.herokuapp.com/"
    var rootURl: String = "http://localhost:9090/"
    var pickerOptions: [String] = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardOnBackgroundTap()
        //saveButton.layer.borderColor = UIColor.green.cgColor
        //saveButton.setTitleColor(UIColor.green, for: UIControlState.normal)
        profileImage.layer.borderWidth = 2
        profileImage.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        bioTextView.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        nameTextView.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        locationTextView.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        locationTextView.clipsToBounds = true
        profileImage.clipsToBounds = true
        bioTextView.clipsToBounds = true
        nameTextView.clipsToBounds = true
        
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        pickerOptions = ["Casual running partners", "Training buddy", "Up for anything", "Meet new friends", "More than friends"]
        //pickerView.selectedRow(inComponent: 3)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
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
            var pickerLabel = view as? UILabel;
            
            if (pickerLabel == nil)
            {
                pickerLabel = UILabel()
                
                pickerLabel?.font = UIFont(name: "Montserrat", size: 14)
                pickerLabel?.textAlignment = NSTextAlignment.center
            }
            
            return pickerOptions[row]
    }
    
    @IBAction func addImageButtonClicked(_ sender: Any) {
        //upload new image from camera roll
    }
    
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        //check if enough data has been entered, save user and send to matching page
    }
    
    // TODO: Figure out how to set the default in the picker and change the font size. Continue messing with UI to make it look better (like adding rounded edges to other text boxes, make bio text start at the top and not middle of text box). More importantly, for functionality I still need to implement the image uploading and strava data integration. Finally, when the save button is clicked, user profile data should be saved and segue to matching view.
}
