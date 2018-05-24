//
//  CreateAccountViewController.swift
//  RunningMates
//
//  Created by dali on 3/1/18.
//  Copyright © 2018 Apple Inc. All rights reserved.
//

import UIKit
import OAuthSwift
import Alamofire
import WebKit
import os.log

class CreateAccountViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var passReconfirmTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var stravaButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    
    var alertView: UIAlertController?
    var webView: WKWebView!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardOnBackgroundTap()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapStrava(_ sender: Any) {
        let rootUrl: String = appDelegate.rootUrl
//        var user = User()
        print("did tap strava")
        let oauthswift = OAuth2Swift(
            consumerKey:    "23426",
            consumerSecret: "0904fa1a2eeff05ab70dcbf642d935f472bbf8ee",     // No secret required
            authorizeUrl:   "https://www.strava.com/oauth/authorize",
            accessTokenUrl: "https://www.strava.com/oauth/token",
            responseType:   "code"
        )
        
        oauthswift.allowMissingStateCheck = true
        oauthswift.authorizeURLHandler = SafariURLHandler(viewController: self, oauthSwift: oauthswift)
        
        let handle = oauthswift.authorize(
            
            withCallbackURL: URL(string: "RunningMates://" + "localhost:9090")!,
            scope: "write", state:"mystate",
            success: { credential, response, parameters in
                print("response token: ")
//                let  createProfileVC = self.storyboard?.instantiateViewController(withIdentifier: "createProfile") as! CreateProfileViewController
//                self.present(createProfileVC, animated: true, completion: nil)
                
                print(credential.oauthToken)
                let params: Parameters = [
                    "token": credential.oauthToken,
                    ]
                let Url = rootUrl + "api/stravaSignup"
                
                let _request = Alamofire.request(Url, method: .post, parameters: params, encoding: URLEncoding.httpBody)
                    .responseJSON { response in
//                        print(response)
                        switch response.result {
                        case .success:
                            print("Post Successful")

                            self.appDelegate.didSignUpWithStrava = 1
                            let user = response.result.value as? [String:Any]!
                            self.appDelegate.userEmail = String(describing: user! ["email"]!)
                            print (self.appDelegate.userEmail)

                            let  createProfileVC = self.storyboard?.instantiateViewController(withIdentifier: "Profile") as! ProfileTableViewController
                            self.present(createProfileVC, animated: true, completion: nil)
                        case .failure(let error):
                            print("failure in creating profile")
                            print(error)
                        }
                }
        },
            failure: { error in
                print(error.localizedDescription)
                print("wrong login")
            }
        )
    }
    
    @IBAction func onCancelButtonClick(_ sender: Any) {
        // Show create account screen
        let  mainVC = self.storyboard?.instantiateViewController(withIdentifier:
            "Main") as! ViewController
        self.present(mainVC, animated: false, completion: nil)
    }
    
    @IBAction func trySignUp(_ sender: Any) {
        let rootUrl: String = appDelegate.rootUrl
        let pass: String? = passTextField.text
        let email: String? = emailTextField.text
        
        // Check to make sure user has filled in all textfields
        if ((passTextField.text! == "") || (emailTextField.text! == "")) {
            let alert = UIAlertController(title: "", message: "Please fill in all required fields to create a new account.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            // Check to make sure email has '@' symbol and username and password are long enough
        } else if (!(emailTextField.text?.contains("@"))!) {
            let alert = UIAlertController(title: "", message: "Please enter a valid email address.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            // Make sure they have entered a long enough username, password, and email
        } else if ((pass?.count)! < 3 || (email?.count)! < 3) {
            let alert = UIAlertController(title: "", message: "Please enter a email, username and password longer than 3 characters.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else if (!(passTextField.text! == passReconfirmTextField.text!)) {
            let alert = UIAlertController(title: "Password Mismatch", message: "Please re-enter your password.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            // If everything looks ok, try to sign them in
            UserManager.instance.requestForSignup(email: email, password: pass, completion: { response in
                if (response == "error") {
                    let alert = UIAlertController(title: "Error Creating Account", message: "Please try again with a different email.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.userEmail = self.emailTextField.text!
                    // If the account creation was successful, send user to create profile page
                    let  createProfileVC : CreateProfileViewController = self.storyboard?.instantiateViewController(withIdentifier: "Profile") as! CreateProfileViewController
                    self.present(createProfileVC, animated: true, completion: nil)
                }
            })
        }
    }
}
