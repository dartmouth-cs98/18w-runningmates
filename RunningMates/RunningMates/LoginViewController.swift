//
//  SignupViewController.swift
//  RunningMates
//
//  Created by Sudikoff Lab iMac on 2/21/18.
//  Copyright © 2018 Apple Inc. All rights reserved.
//

import OAuthSwift
import Alamofire
import UIKit
import WebKit

class LoginViewController: UIViewController, WKUIDelegate {
    
    var webView: WKWebView!
//    var rootURl: String = "https://running-mates.herokuapp.com/"
    var rootURl: String = "http://localhost:9090/"
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("loaded")
        usernameTextField.borderStyle = UITextBorderStyle.roundedRect
        passTextField.borderStyle = UITextBorderStyle.roundedRect
    }
    
    @IBAction func tryLogin(_ sender: Any) {
        let username: String? = usernameTextField.text
        let pass: String? = passTextField.text

        requestForLogin(Url: rootURl + "api/signin", username: username, password: pass)
    }
   

    func requestForLogin(Url:String, username: String?, password: String?) {
        print("username: " + username!)
        print("password: " + password!)

        //var dic=NSDictionary()

        let params: Parameters = [
            "username": username!,
            "password": password!
        ]

        let _request = Alamofire.request(Url, method: .post, parameters: params, encoding: URLEncoding.httpBody)
            .responseString { response in
                switch response.result {
                case .success:
                    print("Post Successful")
                    print("response: " + String(describing: response))
                    //dic=(response.result.value) as! NSDictionary

                    //var error = NSInteger()
                    //error=dic.object(forKey: "error") as! NSInteger

                case .failure(let error):
                    print(error)
                }
        }
//        debugPrint("whole _request ****",_request)
    }
}




