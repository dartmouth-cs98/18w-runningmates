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
    @IBOutlet weak var nameTextView: UITextField!

    @IBOutlet weak var stravaLogo1: UIImageView!
    @IBOutlet weak var stravaLogo2: UIImageView!
    
    //    var rootURl: String = "https://running-mates.herokuapp.com/"
//    // var rootURl: String = "http://localhost:9090/"
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var racesDoneTextView: UITextView!
    @IBOutlet weak var runsPerWeekTextField: UITextField!
    
    var rootUrl = ""
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var saveProf: UIButton!
    var userId: String = UserDefaults.standard.string(forKey: "id")!
    var userEmail: String = UserDefaults.standard.string(forKey: "email")!

    
    var pickerOptions: [String] = [String]()
    var imagePicker: UIImagePickerController = UIImagePickerController()
    
    var newUser: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardOnBackgroundTap()
        self.userEmail = appDelegate.userEmail
        self.rootUrl = appDelegate.rootUrl
        
        self.nameTextView.layer.cornerRadius = 5
        self.bioTextView.layer.cornerRadius = 5
        self.milesPerWeekTextField.layer.cornerRadius = 5
        self.runsPerWeekTextField.layer.cornerRadius = 5
        self.racesDoneTextView.layer.cornerRadius = 5
        
        
        profileImage.layer.borderWidth = 2
        profileImage.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        profileImage.clipsToBounds = true
//        nameTextView.clipsToBounds = true
//        milesPerWeekTextField.clipsToBounds = true
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        imagePicker.delegate = self
        pickerOptions = ["Casual running partners", "Training buddy", "Up for anything", "Meet new friends", "More than friends"]
        //pickerView.selectedRow(inComponent: 3)
        print("did sign up with strava: ")
        print(self.appDelegate.didSignUpWithStrava)
        if (self.appDelegate.didSignUpWithStrava == 0) {
            self.stravaLogo1.isHidden = true
            self.stravaLogo2.isHidden = true
        }
        if (self.appDelegate.didSignUpWithStrava == 1) {
            self.stravaLogo1.isHidden = false
            self.stravaLogo2.isHidden = false
//            getUserRequest(completion: {_ in })
            UserManager.instance.requestUserObject(userEmail: self.userEmail, completion: {user in
                let data : [String:Any] = user.data!
                print(user)
                let urlString = String (describing: user.imageURL)
                let url = URL(string: urlString)
                let imagedata = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                let image = UIImage(data: imagedata!)
                self.profileImage.image = image
                self.nameTextView.text = user.firstName
                self.bioTextView.text = user.bio
                self.milesPerWeekTextField.text = String (describing: data["milesPerWeek"])
                //                    self.totalElevationTextField.text = String (describing: data!! ["totalElevationClimbed"])
                //                    self.totalMilesTextField.text = String (describing: data!! ["totalMilesRun"])
                //                    self.longestRunTextView.text = String (describing: data!! ["longestRun"])
                self.racesDoneTextView.text = data["racesDone"] as! String
                self.runsPerWeekTextField.text = data["runsPerWeek"] as! String
            })
        }
        
        self.nameTextView.text = UserDefaults.standard.value(forKey: "firstName") as! String
        self.bioTextView.text = UserDefaults.standard.value(forKey: "bio") as! String
        
       // self.racesDoneTextView.text = UserDefaults.standard.value(forKey: "racesDone") as! String
        
        if (UserDefaults.standard.value(forKey: "data") != nil) {
            var defaultData: Data = UserDefaults.standard.value(forKey: "data") as! Data
            var data : [String:Any] = NSKeyedUnarchiver.unarchiveObject(with: defaultData) as! [String:Any]
            
            if (data["milesPerWeek"] != nil) {
                if let mpwkText = (data["milesPerWeek"]! as? String) {
                    self.milesPerWeekTextField.text = mpwkText
                }
            }
            
            if (data["runsPerWeek"] != nil) {
                if let runsperweekText = (data["runsPerWeek"] as? String) {
                    self.runsPerWeekTextField.text = runsperweekText
                }
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func updateInfoFromUserDefaults() {
        var firstName: String = UserDefaults.standard.value(forKey: "firstName") as! String
        UserDefaults.standard.set(nameTextView.text, forKey: "firstName")
        var newFirstName: String = UserDefaults.standard.value(forKey: "firstName") as! String
        var data: [String: Any] = UserDefaults.standard.value(forKey: "data") as! [String : Any]

        
        let milespwk:Int? = Int(milesPerWeekTextField.text!)
        data["milesPerWeek"] = milespwk
        
        let runsperWk:Int? = Int(runsPerWeekTextField.text!)
        data["runsPerWeek"] = runsperWk
        
        let racesDoneArray:String? = racesDoneTextView.text!
        data["racesDone"] = racesDoneArray
        
        UserDefaults.standard.set(data, forKey: "data")
        var newData: [String: Any] = UserDefaults.standard.value(forKey: "data") as! [String : Any]
        
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
    
    
    @IBAction func saveClicked(_ sender: Any) {

        //check if enough data has been entered
        if ((nameTextView.text! == "") || (bioTextView.text! == "") || (milesPerWeekTextField.text! == "") || (runsPerWeekTextField.text! == "")) {
            let alert = UIAlertController(title: "", message: "Please fill in all required fields to create a new profile.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        updateInfoFromUserDefaults()
        var dataObj: [String: Any] = UserDefaults.standard.value(forKey: "data") as! [String : Any]
        
        let milespwk:Int? = Int(milesPerWeekTextField.text!)
        
        let runsperWk:Int? = Int(runsPerWeekTextField.text!)
        
        let data: [String: Any] = [
            "milesPerWeek": milespwk,
            "runsPerWeek": runsperWk,
            "totalElevationClimbed": dataObj["totalElevationClimbed"] as! Double,
            "totalMilesRun": dataObj["totalElevationClimbed"] as! Double,
            "averageRunLength": dataObj["totalElevationClimbed"] as! Double,
            ]
        
        // alamofire request
        let params: [String: Any] = [
            "email": self.userEmail,
            "firstName": self.nameTextView.text!,
            "bio":self.bioTextView.text!,
            "data": data
        ]
        
        UserManager.instance.requestUserUpdate(userEmail: self.userEmail, params: params, completion: {title,message in
            print("updated user here!")
            self.updateInfoFromUserDefaults()
        })
        
//        let _request = Alamofire.request(url, method: .post, parameters: params)
//            .responseString { response in
//                switch response.result {
//                case .success:
//                    print("success! response is:")
//                    self.updateInfoFromUserDefaults()
//                    print(response)
//                case .failure(let error):
//                    print("error fetching users")
//                    print(error)
//                }
//        }
        
        
        imageURLsRequest(completion: {  // Get signed URL requests from backend
            self.awsUpload(completion: { // Upload images to aws
                
                let params: [String:Any] = [
                    "email": self.userEmail,
                    "firstName": self.nameTextView.text!,
                    "bio": self.bioTextView.text!,
                    "images": self.profileImageUrls,
                    "milesPerWeek": self.milesPerWeekTextField.text!,
                    "racesDone": self.racesDoneTextView.text!,
                    "runsPerWeek": self.runsPerWeekTextField.text!
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
        
        let isPresentingInAddContactMode = presentingViewController is UINavigationController
        
        if isPresentingInAddContactMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("editing profile error.")
        }
    }
    
    
//    @IBAction func saveButtonClicked(_ sender: Any) {
//        //check if enough data has been entered
//        if ((nameTextView.text! == "") || (bioTextView.text! == "") || (milesPerWeekTextField.text! == "") || (runsPerWeekTextField.text! == "")) {
//        let alert = UIAlertController(title: "", message: "Please fill in all required fields to create a new profile.", preferredStyle: UIAlertControllerStyle.alert)
//        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
//        self.present(alert, animated: true, completion: nil)
//        }
//
//        updateInfoFromUserDefaults()
//
//        imageURLsRequest(completion: {  // Get signed URL requests from backend
//            self.awsUpload(completion: { // Upload images to aws
//
//                let params: [String:Any] = [
//                    "email": self.userEmail,
//                    "firstName": self.nameTextView.text!,
//                    "bio": self.bioTextView.text!,
//                    "images": self.profileImageUrls,
//                    "milesPerWeek": self.milesPerWeekTextField.text!,
////                    "totalElevation": self.totalElevationTextField.text!,
////                    "totalMiles": self.totalMilesTextField.text!,
////                    "longestRun": self.longestRunTextView.text!,
//                    "racesDone": self.racesDoneTextView.text!,
//                    "runsPerWeek": self.runsPerWeekTextField.text!
////                    "kom": self.KOMsTextField.text!,
////                    "frequentSegments": self.frequentSegmentsTextView.text!
//                ]
//
//                UserManager.instance.requestUserUpdate(userEmail: self.userEmail, params: params, completion: { title, message in
//                    //https://www.simplifiedios.net/ios-show-alert-using-uialertcontroller/
//                    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
//                    let defaultAction = UIAlertAction(title: "Close", style: .default, handler: nil)
//                    alertController.addAction(defaultAction)
//
//                    self.present(alertController, animated: true, completion: nil)
//                })
//            })
//        })
//
//    }
    
    
    // needs to be called  only when navigated not from a new user
//    func getUserRequest( completion: @escaping ([String:Any])->()){
//        let rootUrl: String = appDelegate.rootUrl
//        print("in get user")
//
//        let params : [String: Any]
//        params = [
//            "email": self.userEmail
//        ]
//
//        let email: String = self.userEmail
//        let url = rootUrl + "api/users/" + email
//
//        var headers: HTTPHeaders = [
//            "Content-Type": "application/json"
//        ]
//        let _request = Alamofire.request(url, method: .get, parameters: params)
//            .responseJSON { response in
//                switch response.result {
//                case .success:
//                    print("success")
//                    let user = response.result.value as? [String:Any]!
//                    let data = user!["data"] as? [String:Any]?
//                    print(user)
//                    let urlString = String (describing: user! ["imageURL"]!)
//                    let url = URL(string: urlString)
//                    let imagedata = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
//                    let image = UIImage(data: imagedata!)
//                    self.profileImage.image = image
//                    self.nameTextView.text = String(describing: user! ["firstName"]!)
//                    self.bioTextView.text = String(describing: user! ["bio"]!)
//                    self.milesPerWeekTextField.text = String (describing: data!! ["milesPerWeek"])
////                    self.totalElevationTextField.text = String (describing: data!! ["totalElevationClimbed"])
////                    self.totalMilesTextField.text = String (describing: data!! ["totalMilesRun"])
////                    self.longestRunTextView.text = String (describing: data!! ["longestRun"])
//                    self.racesDoneTextView.text = String (describing: data!! ["racesDone"])
//                    self.runsPerWeekTextField.text = String (describing: data!! ["runsPerWeek"])
//                    completion(user!)
//                case .failure(let error):
//                    print("error fetching users")
//                    print(error)
//                }
//        }
//        debugPrint("whole _request ****",_request)
//    }

    
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
