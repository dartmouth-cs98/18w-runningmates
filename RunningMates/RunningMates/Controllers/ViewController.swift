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
            self.hideKeyboardOnBackgroundTap()
        }
    
    @IBAction func didTapCreateAccountButton(_ sender: Any) {
        // Show create account screen
        print("here")
      //  let  createAccountVC = self.storyboard?.instantiateViewController(withIdentifier:
        //    "createAccount") as! CreateAccountViewController
        
        let vc : CreateAccountViewController = self.storyboard?.instantiateViewController(withIdentifier: "createAccount") as! CreateAccountViewController
        /// vc.teststring = "hello"
        print("here")

        self.present(vc, animated: false, completion: nil)
    }

    @IBAction func didTapLogIn(_ sender: UIButton) {
        let vc : LoginViewController = self.storyboard?.instantiateViewController(withIdentifier: "login") as! LoginViewController
        /// vc.teststring = "hello"
        print("here")
        
        self.present(vc, animated: false, completion: nil)
    }
}



