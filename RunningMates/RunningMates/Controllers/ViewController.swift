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
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        var rootURl: String = "https://running-mates.herokuapp.com/"
//        var rootURl: String = "http://localhost:9090/"
        
        @IBOutlet weak var loginButton: UIButton!
        @IBOutlet weak var passTextField: UITextField!
        @IBOutlet weak var emailTextField: UITextField!
        @IBOutlet weak var createAccountButton: UIButton!
        

        override func viewDidLoad() {
            super.viewDidLoad()
            
          //  passTextField.borderStyle = UITextBorderStyle.roundedRect
          //  emailTextField.borderStyle = UITextBorderStyle.roundedRect
            passTextField.layer.cornerRadius = 5
            passTextField.layer.borderWidth = 1
            passTextField.layer.borderColor = UIColor(red: 1.0, green: 0.65, blue: 0.35, alpha: 1.0).cgColor
            
            emailTextField.layer.cornerRadius = 5
            emailTextField.layer.borderWidth = 1
            emailTextField.layer.borderColor = UIColor(red: 1.0, green: 0.65, blue: 0.35, alpha: 1.0).cgColor
            
            loginButton.layer.cornerRadius = 5
            loginButton.layer.borderWidth = 1
            

            createAccountButton.layer.cornerRadius = 5
            createAccountButton.layer.borderWidth = 1

            
            self.hideKeyboardOnBackgroundTap()
        }
    
    @IBAction func didTapCreateAccountButton(_ sender: Any) {
        // Show create account screen
        let  createAccountVC = self.storyboard?.instantiateViewController(withIdentifier:
            "createAccount") as! CreateAccountViewController
        self.present(createAccountVC, animated: false, completion: nil)
    }

    @IBAction func tryLogin(_ sender: UIButton) {
        let rootUrl: String = appDelegate.rootUrl
        
        let pass: String? = passTextField.text
        let email: String? = emailTextField.text
        requestForLogin(Url: rootUrl + "api/signin", password: pass, email: email, completion: {
            
            self.appDelegate.userEmail = self.emailTextField.text!
            
            // https://www.ios-blog.com/tutorials/swift/using-nsuserdefaults-with-swift/
            
            let  matchingVC = self.storyboard?.instantiateViewController(withIdentifier: "matching") as! MatchingViewController
            self.present(matchingVC, animated: true, completion: nil)
            })
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
                    if let jsonUser = response.result.value as? [String:Any] {
                        var user = (jsonUser["user"] as? [String:Any])!
                        
                        // Check token and prevToken storage and comparison if any errors occur
                        let token = (jsonUser["token"] as? String)
                        let prevToken = String(describing: UserDefaults.standard.value(forKey: "token")!)
                        // Check to see if this user is already saved in the UserDefaults, if so, we don't need to save all of their information again.
                        if (prevToken != nil) {
                            if !(token == prevToken) {
                                UserDefaults.standard.set(user["firstName"], forKey: "firstName")
                                UserDefaults.standard.set(user["email"], forKey: "email")
                                UserDefaults.standard.set(token, forKey: "token")
                                if (user["lastName"] != nil) {
                                    UserDefaults.standard.set(user["lastName"], forKey: "lastName")
                                }
                                
                                if (user["imageURL"] != nil) {
                                    UserDefaults.standard.set(user["imageURL"], forKey: "imageURL")
                                }
                                
                                if (user["images"] != nil) {
                                    UserDefaults.standard.set(user["images"], forKey: "images")
                                }
                                
                                if (user["data"] != nil) {
                                    UserDefaults.standard.set(user["data"], forKey: "data")
                                }
                                if (user["desiredGoals"] != nil) {
                                    UserDefaults.standard.set(user["desiredGoals"], forKey: "desiredGoals")
                                }
                            }
                        }
                    }
                    completion()
                case .failure(let error):
                    print(error)
                    let alert = UIAlertController(title: "Error Logging In", message: "Email or password is incorrect", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
        }
    }
}



