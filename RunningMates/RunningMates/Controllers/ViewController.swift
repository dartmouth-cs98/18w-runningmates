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
        var userEmail = UserDefaults.standard.string(forKey: "email")!
        
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
        print(UserDefaults.standard.value(forKey: "location"))
        //temp workaround because location ain't working for anybody
        if (UserDefaults.standard.value(forKey: "location") == nil) {
            let url = rootURl + "api/users/" + self.userEmail
            let location = [-147.349442, 64.751114]
            let params: [String: Any] = [
                "location": location
            ]
            let _request = Alamofire.request(url, method: .post, parameters: params)
                .responseString { response in
                    switch response.result {
                    case .success:
                        print("success! response is:")
                        UserDefaults.standard.set(location, forKey: "location")
                        print(response)
                    case .failure(let error):
                        print("error fetching users")
                        print(error)
                    }
            }
        }
        
       
        
        self.present(vc, animated: false, completion: nil)
    }
}



