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

    class ViewController: UIViewController, WKUIDelegate {

        var webView: WKWebView!
        var rootURl: String = "http://localhost:9090/"
        @IBOutlet weak var loginButton: UIButton!
        @IBOutlet weak var usernameTextField: UITextField!
        @IBOutlet weak var passTextField: UITextField!
        @IBOutlet weak var emailTextField: UITextField!

        override func viewDidLoad() {
            super.viewDidLoad()
            usernameTextField.borderStyle = UITextBorderStyle.roundedRect
            passTextField.borderStyle = UITextBorderStyle.roundedRect
            emailTextField.borderStyle = UITextBorderStyle.roundedRect
        }
    
    @IBAction func didTapStrava(sender: AnyObject) {
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
        let username: String? = usernameTextField.text
        let pass: String? = passTextField.text
        let email: String? = emailTextField.text
        
        requestForLogin(Url: rootURl + "api/signup", username: username, password: pass, email: email)
    }
        
        func requestForLogin(Url:String, username: String?, password: String?, email: String?) {
        
        //var dic=NSDictionary()
            
            let params: Parameters = [
                "email": email!,
                "username": username!,
                "password": password!
            ]
            
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
        debugPrint("whole _request ****",_request)
    }
}



