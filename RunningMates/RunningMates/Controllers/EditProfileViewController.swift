//
//  EditProfileViewController.swift
//  RunningMates
//
//  Created by dali on 4/16/18.
//  Copyright © 2018 Apple Inc. All rights reserved.
//

import UIKit
import OAuthSwift
import Alamofire
import WebKit

class EditProfileViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var longestRunTextView: UITextField!
    @IBOutlet weak var racesDoneTextView: UITextView!
    @IBOutlet weak var frequentSegmentsTextView: UITextView!
    @IBOutlet weak var KOMsTextField: UITextField!
    @IBOutlet weak var totalElevationTextField: UITextField!
    @IBOutlet weak var totalMilesTextField: UITextField!
    @IBOutlet weak var runsPerWeekTextField: UITextField!
    @IBOutlet weak var milesPerWeekTextField: UITextField!
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var locationTextView: UITextField!
    @IBOutlet weak var nameTextView: UITextField!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var pickerOptions: [String] = [String]()
    // var rootURl: String = "https://running-mates.herokuapp.com/"
    var rootURl: String = "http://localhost:9090/"
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var userEmail: String = ""
    
    override func viewDidLoad() {
        self.hideKeyboardOnBackgroundTap()
        self.userEmail = appDelegate.userEmail
        profileImage.layer.borderWidth = 2
        profileImage.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        nameTextView.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        locationTextView.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        milesPerWeekTextField.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        totalMilesTextField.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        totalElevationTextField.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        locationTextView.clipsToBounds = true
        profileImage.clipsToBounds = true
        nameTextView.clipsToBounds = true
        milesPerWeekTextField.clipsToBounds = true
        totalMilesTextField.clipsToBounds = true
        totalElevationTextField.clipsToBounds = true
        
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        pickerOptions = ["Casual running partners", "Training buddy", "Up for anything", "Meet new friends", "More than friends"]
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onAddImageButtonClicked(_ sender: Any) {
    }
    
    @IBAction func onSaveButtonClicked(_ sender: Any) {        //check if enough data has been entered
        if ((nameTextView.text! == "") || (bioTextView.text! == "") || (milesPerWeekTextField.text! == "") || (runsPerWeekTextField.text! == "")) {
            let alert = UIAlertController(title: "", message: "Please fill in all required fields to edit your profile.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }

        backendSaveRequest(completion: { title, message in
            //https://www.simplifiedios.net/ios-show-alert-using-uialertcontroller/
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "Close", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
        })
    }
    
    
    // needs to be called  only when navigated not from a new user
    func getUserRequest( completion: @escaping ([String:Any])->()){
        let rootUrl: String = appDelegate.rootUrl
        
        let params : [String: Any]
        params = [
            "email": self.userEmail
        ]
        
        let email: String = self.userEmail
        let url = rootUrl + "api/users/" + email
        
        var headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        let _request = Alamofire.request(url, method: .get, parameters: params)
            .responseJSON { response in
                switch response.result {
                case .success:
                    let user = response.result.value as? [String:Any]!
                    self.nameTextView.text = String(describing: user! ["firstName"]!)
                    self.bioTextView.text = String(describing: user! ["bio"]!)
                    self.milesPerWeekTextField.text = String (describing: user! ["milesPerWeek"])
                    self.totalElevationTextField.text = String (describing: user! ["totalElevation"])
                    self.totalMilesTextField.text = String (describing: user! ["totalMiles"])
                    self.longestRunTextView.text = String (describing: user! ["longestRun"])
                    self.racesDoneTextView.text = String (describing: user! ["racesDone"])
                    self.runsPerWeekTextField.text = String (describing: user! ["runsPerWeek"])
                    completion(user!)
                case .failure(let error):
                    print("error fetching users")
                    print(error)
                }
        }
        debugPrint("whole _request ****",_request)
    }
    
    
    func backendSaveRequest(completion: @escaping (String, String)-> ()){
        
        let rootUrl: String = appDelegate.rootUrl
        
        let params : [String: Any]
        params = [
            "email": self.userEmail,
            "firstName": nameTextView.text!,
            "bio": bioTextView.text!,
            "location": locationTextView.text!,
            "milesPerWeek": milesPerWeekTextField.text!,
            "totalElevation": totalElevationTextField.text!,
            "totalMiles": totalMilesTextField.text!,
            "longestRun": longestRunTextView.text!,
            "racesDone": racesDoneTextView.text!,
            "runsPerWeek": runsPerWeekTextField.text!,
            "kom": KOMsTextField.text!,
            "frequentSegments": frequentSegmentsTextView.text!
        ]
        
        let email: String = self.userEmail
        let url = rootUrl + "api/user/" + email
        
        var title = ""
        var message = ""
        
        var headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        let _request = Alamofire.request(url, method: .post, parameters: params)
            .responseJSON { response in
                switch response.result {
                case .success:
                    let responseDictionary = response.result.value as! [String:Any]
                    if (String(describing: responseDictionary["response"]!) == "updated user") {
                        title = "You Have Updated Your Profile"
                        message = "Find Some New RunningMates!"
                    }
                    print("*** success in update*** ")
                case .failure(let error):
                    print("*error posting profile updates*")
                    print(error)
                }
                completion(title, message)
        }
        debugPrint("whole _request ****",_request)
    }
}
