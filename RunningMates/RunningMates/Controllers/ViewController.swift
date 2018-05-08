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
        var rootURl: String = ""
        
        @IBOutlet weak var loginButton: UIButton!
        @IBOutlet weak var passTextField: UITextField!
        @IBOutlet weak var emailTextField: UITextField!
        @IBOutlet weak var createAccountButton: UIButton!
        

        override func viewDidLoad() {
            super.viewDidLoad()
            
            rootURl = appDelegate.rootUrl;
            
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
        UserManager.instance.requestForLogin(Url: rootUrl + "api/signin", password: pass, email: email, completion: { id in
            
            if (id == "error") {
//                print(error)
                let alert = UIAlertController(title: "Error Logging In", message: "Email or password is incorrect", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
            
                self.appDelegate.userEmail = self.emailTextField.text!
            
                let storyboard : UIStoryboard = UIStoryboard(name: "Matching", bundle: nil)
                let vc : MatchingViewController = storyboard.instantiateViewController(withIdentifier: "matchingView") as! MatchingViewController
               /// vc.teststring = "hello"
                
                let navigationController = UINavigationController(rootViewController: vc)
                
                self.present(navigationController, animated: true, completion: nil)
                
                // https://www.ios-blog.com/tutorials/swift/using-nsuserdefaults-with-swift/
//
//                let  matchingVC = self.storyboard?.instantiateViewController(withIdentifier: "matching") as! MatchingViewController
//                self.present(matchingVC, animated: true, completion: nil)
//
                print("before socket")
                SocketIOManager.instance.login(userID: id)
        
            }
        })
    }
}



