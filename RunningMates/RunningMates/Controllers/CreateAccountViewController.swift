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
//    var rootURl: String = "https://running-mates.herokuapp.com/"
//    var rootURl: String = "http://localhost:9090/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardOnBackgroundTap()
        
        passReconfirmTextField.borderStyle = UITextBorderStyle.roundedRect
        passTextField.borderStyle = UITextBorderStyle.roundedRect
        emailTextField.borderStyle = UITextBorderStyle.roundedRect
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
            
            withCallbackURL: URL(string: "RunningMates://" + rootUrl)!,
            scope: "write", state:"mystate",
            success: { credential, response, parameters in
                print("response token: ")
                let  createProfileVC = self.storyboard?.instantiateViewController(withIdentifier: "createProfile") as! CreateProfileViewController
                self.present(createProfileVC, animated: true, completion: nil)
                
                print(credential.oauthToken)
                let params: Parameters = [
                    "token": credential.oauthToken,
                    ]
                let Url = rootUrl + "api/stravaSignup"
                
                let _request = Alamofire.request(Url, method: .post, parameters: params, encoding: URLEncoding.httpBody)
                    .responseJSON { response in
                        switch response.result {
                        case .success:
                            print("Post Successful")
                            // Brians edits
//                            print(response.result.value.data)
//                            // let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                            appDelegate.userData = response.result.value.data! // format of key value pairs
//                            appDelegate.firstName = response.result.value.firstName.text!
//                            appDelegate.lastName = response.result.value.lastName.text!
//                            appDelegate.age = response.result.value.age.int!
//                            appDelegate.email = response.result.value.email.text!
                            
                            // first name last name bio age email data
                            
                            // or is it like this
//                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//
//                            if let jsonResult = response.result.value as? [[String:Any]] {
//                                do {
//                                    let user1 = try User(json: (jsonUser["user"] as? [String:Any])!)
//                                    if (user != nil) {
//                                        print("User")
//                                        print(user!)
//                                        user = user1
//                                        completion((user?.id)!) // what does this do
//                                    } else {
//                                        print("nil")
//                                    }
//                                } catch UserInitError.invalidId {
//                                    print("invalid id")
//                                } catch UserInitError.invalidFirstName {
//                                    print("invalid first name")
//                                } catch UserInitError.invalidLastName {
//                                    print("invalid last name")
//                                } catch UserInitError.invalidImageURL {
//                                    print("invalid image url")
//                                } catch UserInitError.invalidBio {
//                                    print("invalid bio")
//                                } catch UserInitError.invalidGender {
//                                    print("invalid gender")
//                                } catch UserInitError.invalidAge {
//                                    print("invalid age")
//                                } catch UserInitError.invalidLocation {
//                                    print("invalid location")
//                                } catch UserInitError.invalidEmail {
//                                    print("invalid email")
//                                } catch UserInitError.invalidPassword {
//                                    print("invalid password")
//                                } catch {
//                                    print("other error")
//                                }
//                            }
                            
                            // need to pass the user object to the next screen
                            
                            let  createProfileVC = self.storyboard?.instantiateViewController(withIdentifier: "createProfile") as! CreateProfileViewController
                            self.present(createProfileVC, animated: true, completion: nil)
                        case .failure(let error):
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
            requestForLogin(Url: rootUrl + "api/signup", password: pass, email: email, completion: {
                print("completion")
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.userEmail = self.emailTextField.text!
                // If the account creation was successful, send user to create profile page
                let  createProfileVC = self.storyboard?.instantiateViewController(withIdentifier: "createProfile") as! CreateProfileViewController
                self.present(createProfileVC, animated: true, completion: nil)
            })
        }
    }
    
    func requestForLogin(Url:String, password: String?, email: String?, completion: @escaping ()->()) {
        
        let params: Parameters = [
            "email": email!,
            "password": password!
        ]
        
        let _request = Alamofire.request(Url, method: .post, parameters: params, encoding: JSONEncoding.default)
            .responseJSON { response in
                switch response.result {
                case .success:
                    completion()
                case .failure(let error):
                    let alert = UIAlertController(title: "Error Creating Account", message: "Please try again with a different email.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    print(error)
                }
        }
        debugPrint("whole _request ****",_request)
    }
}
