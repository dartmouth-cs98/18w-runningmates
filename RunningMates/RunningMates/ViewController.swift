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
            let  createAccountVC = self.storyboard?.instantiateViewController(withIdentifier:
                "createAccount") as! CreateAccountViewController
            self.present(createAccountVC, animated: true, completion: nil)
        }

    @IBAction func tryLogin(_ sender: UIButton) {
        let pass: String? = passTextField.text
        let email: String? = emailTextField.text
        requestForLogin(Url: rootURl + "api/signin", password: pass, email: email)
    }
        
    func requestForLogin(Url:String, password: String?, email: String?) {
            
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
                    
                case .failure(let error):
                    print(error)
                }
        }
        debugPrint("whole _request ****",_request)
    }
}



