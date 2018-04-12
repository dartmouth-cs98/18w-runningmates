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
        
//        var rootURl: String = "https://running-mates.herokuapp.com/"
//        var rootURl: String = "http://localhost:9090/"
        
        @IBOutlet weak var loginButton: UIButton!
        @IBOutlet weak var passTextField: UITextField!
        @IBOutlet weak var emailTextField: UITextField!
        @IBOutlet weak var createAccountButton: UIButton!
        
        var userInstance: User!

        override func viewDidLoad() {
            super.viewDidLoad()
            
            passTextField.borderStyle = UITextBorderStyle.roundedRect
            emailTextField.borderStyle = UITextBorderStyle.roundedRect
            
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
            print(self.appDelegate.userEmail)
            
            let  matchingVC = self.storyboard?.instantiateViewController(withIdentifier: "matching") as! MatchingViewController
            self.present(matchingVC, animated: true, completion: nil)
            })
    }
        
    func requestForLogin(Url:String, password: String?, email: String?, completion: @escaping (User)->()) -> User {

        print("requestForLogin")
        
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
                        var token = (jsonUser["token"] as? [String:Any])
                        UserDefaults.setValue(user["firstName"], forKey: "firstName")
                        UserDefaults.setValue(user["email"], forKey: "email")
                        UserDefaults.setValue(token, forKey: "token")
                        if (user["lastName"] != nil) {
                            UserDefaults.setValue(user["lastName"], forKey: "firstName")
                        }
                        
                        if (user["imageURL"] != nil) {
                            UserDefaults.setValue(user["imageURL"], forKey: "firstName")
                        }
                        
                        if (user["images"] != nil) {
                            UserDefaults.setValue(user["images"], forKey: "firstName")
                        }
                        
                        if (user["data"] != nil) {
                            UserDefaults.setValue(user["data"], forKey: "firstName")
                        }
                        if (user["desiredGoals"] != nil) {
                            UserDefaults.setValue(user["desiredGoals"], forKey: "firstName")
                        }

                    }
                        
                case .failure(let error):
                    print(error)
                    let alert = UIAlertController(title: "Error Logging In", message: "Email or password is incorrect", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
        }
        return user
    }
}



