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


struct signedUrlObject {
    var signedRequest: String
    var url: String
}

class CreateProfileViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    var profileImages: [Int: UIImageView] = [:]
    var profileImageNames: [Int: String] = [:]
    var profileImageUrls: [Int: String] = [:]
    var signUrls: [signedUrlObject] = []
    @IBOutlet weak var profileImage_0: UIImageView!
    @IBOutlet weak var profileImage_1: UIImageView!
    @IBOutlet weak var profileImage_2: UIImageView!
    @IBOutlet weak var profileImage_3: UIImageView!
    @IBOutlet weak var profileImage_4: UIImageView!
    @IBOutlet weak var profileImage_5: UIImageView!
   
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var milesPerWeekTextField: UITextField!
    @IBOutlet weak var totalElevationTextField: UITextField!
    @IBOutlet weak var nameTextView: UITextField!
    @IBOutlet weak var totalMilesTextField: UITextField!
    @IBOutlet weak var locationTextView: UITextField!

    var rootURl: String = "https://running-mates.herokuapp.com/"
    // var rootURl: String = "http://localhost:9090/"
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var longestRunTextView: UITextField!
    @IBOutlet weak var racesDoneTextView: UITextView!
    @IBOutlet weak var frequentSegmentsTextView: UITextView!
    @IBOutlet weak var KOMsTextField: UITextField!
    @IBOutlet weak var runsPerWeekTextField: UITextField!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var userId: String = UserDefaults.standard.string(forKey: "id")!
    var userEmail: String = UserDefaults.standard.string(forKey: "email")!

    
    var pickerOptions: [String] = [String]()
    var imagePicker: UIImagePickerController = UIImagePickerController()
    
    var newUser: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        imagePicker.delegate = self
        pickerOptions = ["Casual running partners", "Training buddy", "Up for anything", "Meet new friends", "More than friends"]
        //pickerView.selectedRow(inComponent: 3)
        print("did sign up with strava: ")
        print(self.appDelegate.didSignUpWithStrava)
        if (self.appDelegate.didSignUpWithStrava == 1) {
            getUserRequest(completion: {_ in })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    func updateInfoFromUserDefaults() {
        var firstName: String = UserDefaults.standard.value(forKey: "firstName") as! String as! String
        var data: [String: Any] = UserDefaults.standard.value(forKey: "data") as! [String : Any]
        if (firstName != nil) {
            nameTextView.text = firstName
        }
//        if (data["totalMilesRun"] != nil) {
//            totalMilesTextField.text = data["totalMilesRun"]
//        }
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
    
    // In the delegate method, set the profile image to the image the user picked based on the image icon clicked
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any], imageNumber: Int) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        let tempImage = UIImageView()
        tempImage.image = image
        let imageName = self.userId + "_" + String(imageNumber) + "_" + self.userId
        profileImages.updateValue(tempImage, forKey: imageNumber)
        profileImageNames.updateValue(imageName, forKey: imageNumber)

        dismiss(animated:true, completion: nil)
    }
    
//    func imagePickerControllerZero(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
//        profileImage_0.image = image
//        dismiss(animated:true, completion: nil)
//    }
//
//    func imagePickerControllerOne(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
//        profileImage_1.image = image
//        dismiss(animated:true, completion: nil)
//    }
//
//    func imagePickerControllerTwo(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
//        profileImage_2.image = image
//        dismiss(animated:true, completion: nil)
//    }
//
//    func imagePickerControllerThree(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
//        profileImage_3.image = image
//        dismiss(animated:true, completion: nil)
//    }
//
//    func imagePickerControllerFour(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
//        profileImage_4.image = image
//        dismiss(animated:true, completion: nil)
//    }
//
//    func imagePickerControllerFive(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
//        profileImage_5.image = image
//        dismiss(animated:true, completion: nil)
//    }
//
    
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        //check if enough data has been entered
        if ((nameTextView.text! == "") || (bioTextView.text! == "") || (milesPerWeekTextField.text! == "") || (runsPerWeekTextField.text! == "")) {
        let alert = UIAlertController(title: "", message: "Please fill in all required fields to create a new profile.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        }
        
        imageURLsRequest(completion: {  // Get signed URL requests from backend
            self.awsUpload(completion: { // Upload images to aws
                
                let params: [String:Any] = [
                    "email": self.userEmail,
                    "firstName": self.nameTextView.text!,
                    "bio": self.bioTextView.text!,
                    "images": self.profileImageUrls,
                    "milesPerWeek": self.milesPerWeekTextField.text!,
                    "totalElevation": self.totalElevationTextField.text!,
                    "totalMiles": self.totalMilesTextField.text!,
                    "longestRun": self.longestRunTextView.text!,
                    "racesDone": self.racesDoneTextView.text!,
                    "runsPerWeek": self.runsPerWeekTextField.text!,
                    "kom": self.KOMsTextField.text!,
                    "frequentSegments": self.frequentSegmentsTextView.text!
                ]
                
                UserManager.instance.requestUserUpdate(userEmail: self.userEmail, params: params, completion: { title, message in
                    //https://www.simplifiedios.net/ios-show-alert-using-uialertcontroller/
                    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "Close", style: .default, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                })
            })
        })

    }
    
    
    // needs to be called  only when navigated not from a new user
    func getUserRequest( completion: @escaping ([String:Any])->()){
        let rootUrl: String = appDelegate.rootUrl
        print("in get user")
        
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
                    print("success")
                    let user = response.result.value as? [String:Any]!
                    let data = user!["data"] as? [String:Any]?
                    print(user)
                    let urlString = String (describing: user! ["imageURL"]!)
                    let url = URL(string: urlString)
                    let imagedata = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                    let image = UIImage(data: imagedata!)
                    self.profileImage.image = image
                    self.nameTextView.text = String(describing: user! ["firstName"]!)
                    self.bioTextView.text = String(describing: user! ["bio"]!)
                    self.milesPerWeekTextField.text = String (describing: data!! ["milesPerWeek"])
                    self.totalElevationTextField.text = String (describing: data!! ["totalElevationClimbed"])
                    self.totalMilesTextField.text = String (describing: data!! ["totalMilesRun"])
                    self.longestRunTextView.text = String (describing: data!! ["longestRun"])
                    self.racesDoneTextView.text = String (describing: data!! ["racesDone"])
                    self.runsPerWeekTextField.text = String (describing: data!! ["runsPerWeek"])
                    completion(user!)
                case .failure(let error):
                    print("error fetching users")
                    print(error)
                }
        }
        debugPrint("whole _request ****",_request)
    }

    
//    func backendSaveRequest(completion: @escaping (String, String)-> ()){
//
//        let rootUrl: String = appDelegate.rootUrl
//
//        let params: [String:Any] = [
//                "email": self.userEmail,
//                "firstName": nameTextView.text!,
//                "bio": bioTextView.text!,
//                "images": self.profileImageUrls,
//                "milesPerWeek": milesPerWeekTextField.text!,
//                "totalElevation": totalElevationTextField.text!,
//                "totalMiles": totalMilesTextField.text!,
//                "longestRun": longestRunTextView.text!,
//                "racesDone": racesDoneTextView.text!,
//                "runsPerWeek": runsPerWeekTextField.text!,
//                "kom": KOMsTextField.text!,
//                "frequentSegments": frequentSegmentsTextView.text!
//            ]
//
//        let email: String = self.userEmail
//        let url = rootUrl + "api/user/" + email
//
//        var title = ""
//        var message = ""
//
//        let _request = Alamofire.request(url, method: .post, parameters: params)
//            .responseJSON { response in
//                switch response.result {
//                case .success:
//                    let responseDictionary = response.result.value as! [String:Any]
//                    if (responseDictionary != nil && responseDictionary["response"] != nil) {
//                        if (String(describing: responseDictionary["response"]!) == "updated user") {
//                            title = "You Have Updated Your Profile"
//                            message = "Find Some New RunningMates!"
//                        }
//                        completion(title, message)
//                        print("*** success in update*** ")
//                    }
//                case .failure(let error):
//                    print("*error posting profile updates*")
//                    print(error)
//                }
//        }
//         debugPrint("whole _request ****",_request)
//    }
    
    func awsUpload(completion: @escaping ()->()){
        
        let headers: HTTPHeaders = [
            "Content-Type": "image/jpeg"
        ]
        
        for (key, imageObject) in self.profileImages {
            let image = imageObject.image
            let imageData = UIImageJPEGRepresentation(image!, 0.7)
            let request = Alamofire.upload(imageData!, to: self.signUrls[key].signedRequest, method: .put, headers: headers)
                .responseData {
                    response in
                    if response.response != nil {
                        self.profileImageUrls.updateValue(self.signUrls[key].url, forKey: key)
                        
                    }
                    else {
                        print("Something went wrong uploading")
                    }
                    
                }
        }
        completion()
    }
    func imageURLsRequest (completion: @escaping ()-> ()){
        
        let rootUrl: String = appDelegate.rootUrl
        let Url = rootUrl + "/sign-s3"
        
        let params: Parameters = [
            "file-names": self.profileImageUrls,
            "file-type": "image/jpeg",
        ]
        
        let _request = Alamofire.request(Url, method: .get, parameters: params, encoding: JSONEncoding.default)
            .responseJSON { response in
                switch response.result {
                case .success:
                    if let jsonSignedUrls = response.result.value as? [signedUrlObject] {
                        self.signUrls = jsonSignedUrls
                    }
                    
                case .failure(let error):
                    print("Error getting signed URLs")
                    print(error)
                }
        }
    }
}
