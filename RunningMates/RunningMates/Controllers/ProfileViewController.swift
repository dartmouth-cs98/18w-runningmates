//
//  ProfileViewController.swift
//  RunningMates
//
//  Created by Divya Kalidindi on 2/15/18.
//  Copyright © 2018 Apple Inc. All rights reserved.
//


import UIKit
import Alamofire
// https://developer.apple.com/library/content/referencelibrary/GettingStarted/DevelopiOSAppsSwift/WorkWithViewControllers.html#//apple_ref/doc/uid/TP40015214-CH6-SW1 for image picking

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var bioTextField: UITextView!
    @IBOutlet weak var photoImageView: UIImageView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
//    var rootURl: String = "http://localhost:9090/"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        print("canceled")
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        print("in imagePickerController")
        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // https://stackoverflow.com/questions/47916207/how-to-get-image-extension-format-from-uiimage-in-swift
        let assetPath = info[UIImagePickerControllerReferenceURL] as! NSURL
        let imgType = assetPath.pathExtension
        
        print("type:")
        //print(String(describing: imgType))
        
        // Set photoImageView to display the selected image.
        photoImageView.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    

    //MARK: Actions

    
    @IBAction func editProfileImage(_ sender: Any) {
        print("in edit profile image")
        // Hide the keyboard.
        //nameTextField.resignFirstResponder()
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
//    @IBAction func selectImageFromPhotoLibrary(_ sender: UIButton) {
//
//    }
    
    
    @IBAction func saveChanges(_ sender: Any) {
        print("You clicked save.")
        let rootUrl: String = appDelegate.rootUrl
        
        // alamofire request
        let params: [String: Any] = [
            "file-name": "name",
            "file-type": "type"
        ]
        
        let url = rootUrl + "api/signS3"
        
        let _request = Alamofire.request(url, method: .post, parameters: params)
            .responseJSON { response in
                switch response.result {
                case .success:
                    print("success! response is:")
                    //print(response)
                case .failure(let error):
                    print("error fetching users")
                    print(error)
                }
        }
    }
    
}
