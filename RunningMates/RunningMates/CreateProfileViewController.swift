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

class CreateProfileViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var averagePaceTextField: UITextField!
   // @IBOutlet weak var bioTextView: UITextField!
    @IBOutlet weak var totalElevationTextField: UITextField!
    @IBOutlet weak var nameTextView: UITextField!
    @IBOutlet weak var totalMilesTextField: UITextField!
    @IBOutlet weak var locationTextView: UITextField!
    //var rootURl: String = "https://running-mates.herokuapp.com/"
    var rootURl: String = "http://localhost:9090/"
    var pickerOptions: [String] = [String]()
    var imagePicker: UIImagePickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardOnBackgroundTap()
        profileImage.layer.borderWidth = 2
        profileImage.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        //bioTextView.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        nameTextView.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        locationTextView.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        averagePaceTextField.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        totalMilesTextField.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        totalElevationTextField.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        locationTextView.clipsToBounds = true
        profileImage.clipsToBounds = true
       // bioTextView.clipsToBounds = true
        nameTextView.clipsToBounds = true
        averagePaceTextField.clipsToBounds = true
        totalMilesTextField.clipsToBounds = true
        totalElevationTextField.clipsToBounds = true
        
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        imagePicker.delegate = self
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
            return pickerOptions[row]
    }
    
    // Access their photo library and ask user to pick a photo
    @IBAction func addImageButtonClicked(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    // In the delegate method, set the profile image to the image the user picked
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        profileImage.image = image
        dismiss(animated:true, completion: nil)
    }
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        //check if enough data has been entered, save user and send to matching page
    }
    
    // TODO: Figure out how to set the default in the picker and change the font size. Continue messing with UI to make it look better. More importantly, for functionality I still need to implement the image uploading and strava data integration. Finally, when the save button is clicked, user profile data should be saved and segue to matching view.
}
