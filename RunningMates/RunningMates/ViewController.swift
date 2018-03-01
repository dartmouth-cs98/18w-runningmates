//
//  ViewController.swift
//  RunningMates
//
//  Created by Sara Topic on 30/01/2018.
//  Copyright © 2018 Apple Inc. All rights reserved.
//
import OAuthSwift
import Alamofire
import UIKit
import WebKit

extension UIViewController {
    
    // Use this function to hide the soft keyboard when the user taps the background
    func hideKeyboardOnBackgroundTap() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

    class ViewController: UIViewController, WKUIDelegate, UINavigationControllerDelegate {

        var webView: WKWebView!
//        var rootURl: String = "https://running-mates.herokuapp.com/"
        var rootURl: String = "http://localhost:9090/"
        @IBOutlet weak var loginButton: UIButton!
        @IBOutlet weak var passTextField: UITextField!
        @IBOutlet weak var emailTextField: UITextField!
        @IBOutlet weak var createAccountButton: UIButton!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            passTextField.borderStyle = UITextBorderStyle.roundedRect
            emailTextField.borderStyle = UITextBorderStyle.roundedRect
            
            self.hideKeyboardOnBackgroundTap()
        }
    
        @IBAction func didTapCreateAccountButton(_ sender: Any) {
            // Show create account screen
            let  createAccountVC = self.storyboard?.instantiateViewController(withIdentifier: "createAccount") as! CreateAccountViewController
            self.present(createAccountVC, animated: true, completion: nil)
        }
        
        @IBAction func didTapStrava(_ sender: Any) {
       // }
        //@IBAction func didTapStrava(sender: AnyObject) {
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
            
            
            withCallbackURL: URL(string: "RunningMates://localhost:9090")!,
            scope: "write", state:"mystate",
            success: { credential, response, parameters in
                print("response token: ")
                let  matchingVC = self.storyboard?.instantiateViewController(withIdentifier: "matching") as! MatchingViewController
                self.present(matchingVC, animated: true, completion: nil)

                print(credential.oauthToken)
                let params: Parameters = [
                    "token": credential.oauthToken,
                    
                    

                ]
                let Url = self.rootURl + "api/stravaSignup"
                
                let _request = Alamofire.request(Url, method: .post, parameters: params, encoding: URLEncoding.httpBody)
                    .responseJSON { response in
                        switch response.result {
                        case .success:
                            print("Post Successful")
                            //dic=(response.result.value) as! NSDictionary
                            
                            //var error = NSInteger()
                            //error=dic.object(forKey: "error") as! NSInteger
                            
                        case .failure(let error):
                            print(error)
                        }
                }
                // Do your request
        },
            failure: { error in
                print(error.localizedDescription)
                print("wrong login")
        }
        )
    }

    @IBAction func tryLogin(_ sender: UIButton) {
        let pass: String? = passTextField.text
        let email: String? = emailTextField.text
        
        // Check to make sure user has filled in all textfields
        if ((passTextField.text == "") || (emailTextField.text == "")) {
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
        } else {
            // If everything looks ok, try to sign them in
            requestForLogin(Url: rootURl + "api/signup", password: pass, email: email)
        }
    }
        
    func requestForLogin(Url:String, password: String?, email: String?) {
    
    //var dic=NSDictionary()
        
        let params: Parameters = [
            "email": email!,
            "password": password!
        ]
        
        let _request = Alamofire.request(Url, method: .post, parameters: params, encoding: JSONEncoding.default)
            .responseJSON { response in
                switch response.result {
                case .success:
                    print("Post Successful")
                    print(response)
                    let  matchingVC = self.storyboard?.instantiateViewController(withIdentifier: "matching") as! MatchingViewController
                    self.present(matchingVC, animated: true, completion: nil)

                    //dic=(response.result.value) as! NSDictionary
                    
                    //var error = NSInteger()
                    //error=dic.object(forKey: "error") as! NSInteger
                    
                case .failure(let error):
                    print(error)
                }
        }
        debugPrint("whole _request ****",_request)
    }
}



