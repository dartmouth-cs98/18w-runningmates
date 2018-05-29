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
//        var userEmail = UserDefaults.standard.string(forKey: "email")!

        @IBOutlet weak var loginButton: UIButton!
        @IBOutlet weak var passTextField: UITextField!
        @IBOutlet weak var emailTextField: UITextField!
        @IBOutlet weak var createAccountButton: UIButton!
        
        @IBOutlet weak var everyoneLabel: UILabel!
        
    

        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)

            let token: String? = UserDefaults.standard.string(forKey: "token")
            if (token != nil && token != "") {
                // go to Matching view
                let storyboard : UIStoryboard = UIStoryboard(name: "Matching", bundle: nil)
                let vc : MatchingViewController = storyboard.instantiateViewController(withIdentifier: "matchingView") as! MatchingViewController
                let navigationController = UINavigationController(rootViewController: vc)

                self.present(navigationController, animated: true, completion: nil)
            }
        }

        override func viewDidLoad() {
            super.viewDidLoad()
            view.addBackground(imageName: "running1")
            self.createAccountButton.backgroundColor = .clear
            self.createAccountButton.layer.borderWidth = 1.5
            self.createAccountButton.layer.borderColor = UIColor.white.cgColor
            
            self.loginButton.backgroundColor = .clear
            self.loginButton.layer.borderWidth = 1.5
            self.loginButton.layer.borderColor = UIColor(red: 1, green: 0.7686, blue: 0.1765, alpha: 1.0).cgColor
            rootURl = appDelegate.rootUrl;
            self.hideKeyboardOnBackgroundTap()
        }
    
    @IBAction func didTapCreateAccountButton(_ sender: Any) {
        // Show create account screen
        let vc : CreateAccountViewController = self.storyboard?.instantiateViewController(withIdentifier: "createAccount") as! CreateAccountViewController

        self.present(vc, animated: false, completion: nil)
    }

    @IBAction func didTapLogIn(_ sender: UIButton) {
        let vc : LoginViewController = self.storyboard?.instantiateViewController(withIdentifier: "login") as! LoginViewController

//        print(UserDefaults.standard.value(forKey: "location"))
//        //temp workaround because location ain't working for anybody
//        if (UserDefaults.standard.value(forKey: "location") == nil) {
//            let email : String = UserDefaults.standard.value(forKey: "email") as! String
//            let url = rootURl + "api/users/" + email
//            let location = [-147.349442, 64.751114]
//            let params: [String: Any] = [
//                "location": location
//            ]
//            let _request = Alamofire.request(url, method: .post, parameters: params)
//                .responseString { response in
//                    switch response.result {
//                    case .success:
//                        print("success! response is:")
//                        UserDefaults.standard.set(location, forKey: "location")
//                        print(response)
//                    case .failure(let error):
//                        print("error fetching users")
//                        print(error)
//                    }
//            }
//        }
        
       
        
        self.present(vc, animated: false, completion: nil)
    }
}



