//
//  ProfPicViewController.swift
//  RunningMates
//
//  Created by Divya Kalidindi on 5/24/18.
//  Copyright © 2018 Apple Inc. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import EMAlertController

class ProfPicViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var addImageButton: UIButton!
    
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    var userId: String? = nil
    var userEmail: String? = nil
    var pickerOptions: [String] = [String]()
    var imagePicker = UIImagePickerController()
    
    var profileImages: [Int: UIImageView] = [:]
    var imageName = ""
    var profileImageUrl = ""
    var profileImageNames: [Int: String] = [:]
    var profileImageUrls: [Int: String] = [:]
    
    var signUrls: [AnyObject] = []
    var rootUrl = ""
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var newUser: User!
    var didChooseImage = false
    
    override func viewDidLoad() {
        //super.viewDidLoad()
        self.userId = UserDefaults.standard.string(forKey: "id")!
        self.userEmail = UserDefaults.standard.string(forKey: "email")!
                
        self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2;
        self.profileImage.clipsToBounds = true;
        self.profileImage.layer.borderWidth = 6;
        self.profileImage.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1.0).cgColor
        
        
        self.hideKeyboardOnBackgroundTap()
        self.userEmail = UserDefaults.standard.value(forKey: "email") as? String
        self.rootUrl = appDelegate.rootUrl
        imagePicker.delegate = self
        
        //https://stackoverflow.com/questions/8077740/how-to-fill-background-image-of-an-uiview
        
//        view.addBackground()
//
//        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.regular)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.frame = view.bounds
//        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//
//
//        // Vibrancy Effect
//        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
//        let vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
//        vibrancyEffectView.frame = view.bounds
//
//        // Label for vibrant text
//        let vibrantLabel = UILabel()
//        vibrantLabel.text = "Vibrant"
//        vibrantLabel.font = UIFont.systemFont(ofSize: 72.0)
//        vibrantLabel.sizeToFit()
//        vibrantLabel.center = view.center
//
//        // Add label to the vibrancy view
//        vibrancyEffectView.contentView.addSubview(vibrantLabel)
//
//        // Add the vibrancy view to the blur view
//        blurEffectView.contentView.addSubview(vibrancyEffectView)
//        view.addSubview(blurEffectView)
//        view.addSubview(infoView)

    }

    @IBAction func addImageButton(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = true;
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    // In the delegate method, set the profile image to the image the user picked based on the image icon clicked
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let tempImage = UIImageView()
            tempImage.image = image
            imageName = self.userId! + "_0"
            profileImage.image = image
            self.didChooseImage = true
            addImageButton.isHidden = true
        
        }
        dismiss(animated:true, completion: nil)
    }
    
    func awsUpload(userImageUpdateUrlObject: [AnyObject], completion: @escaping (String)->()){
        
        let headers: HTTPHeaders = [
            "Content-Type": "image/jpeg"
        ]
        let image = profileImage.image
        let imageData = UIImageJPEGRepresentation(image!, 0.7)
        print("signed object: \n\n\n ", userImageUpdateUrlObject)
        if let signedOb = userImageUpdateUrlObject[0]["signedRequest"] as? String {
            let request = Alamofire.upload(imageData!, to: signedOb, method: .put, headers: headers)
                .responseData {
                    response in
                    if response.response != nil {
                        let awsUrl = userImageUpdateUrlObject[0]["url"] as? String
                        
                        self.profileImageUrl = awsUrl!
                        completion(awsUrl!)
                        
                    }
                    else {
                        print("Something went wrong uploading")
                    }
            }
        }
    }
    
    func imageURLsRequest (completion: @escaping ([AnyObject])-> ()){
        
        let rootUrl: String = appDelegate.rootUrl
        let Url = rootUrl + "api/sign-s3"
        let fileName = [self.imageName]
        
        let params: Parameters = [
            "fileNames": fileName,
            "fileType": "image/jpeg",
            ]
        
        let _request = Alamofire.request(Url, method: .post, parameters: params, encoding: JSONEncoding.default)
            .responseJSON { response in
                switch response.result {
                case .success:
                    if let jsonSignedUrls = response.result.value as? [AnyObject] {
                        
                        self.signUrls = jsonSignedUrls
                        
                        completion(jsonSignedUrls)
                    }
                    
                case .failure(let error):
                    print("Error getting signed URLs")
                    print(error)
                }
        }
        
    }
    
    @IBAction func nextButton(_ sender: Any) {
        if (self.didChooseImage == false) {
            let alert = EMAlertController(title: "Uh oh!", message: "Looks like you didn't choose a picture! We get it, sometimes following simple instructions is hard.")
            let cancel = EMAlertAction(title: "Got it!", style: .cancel)
            alert.addAction(action: cancel)
            self.present(alert, animated: true, completion: nil)
        }
        else {
            //check if enough data has been entered
            imageURLsRequest(completion: {
                successUrlRequest in// Get signed URL requests from backend
                self.awsUpload(userImageUpdateUrlObject: successUrlRequest, completion: { // Upload images to aws
                    awsUrl in
                    var userImages = [String]()
                    userImages.append(awsUrl);
                    let params: [String:Any] = [
                        "email": self.userEmail,
                        "images": userImages,
                        ]
                    
                    UserManager.instance.requestUserUpdate(userEmail: self.userEmail!, params: params, completion: { title, message in
                        //https://www.simplifiedios.net/ios-show-alert-using-uialertcontroller/
                        print("\n\n user images: \n\n", userImages)
                        UserDefaults.standard.set(userImages, forKey: "images")
                        UserDefaults.standard.synchronize()
                        
                        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                        
                        let defaultAction = UIAlertAction(title: "Close", style: .default, handler: nil)
                        alertController.addAction(defaultAction)
                        
                        self.present(alertController, animated: true, completion: nil)
                    })
                })
            })
        }
    }
}
