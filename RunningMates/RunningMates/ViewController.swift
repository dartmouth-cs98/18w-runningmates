//
//  ViewController.swift
//  RunningMates
//
//  Created by Sara Topic on 30/01/2018.
//  Copyright © 2018 Apple Inc. All rights reserved.
//
import OAuthSwift
import UIKit
import WebKit

    class ViewController: UIViewController, WKUIDelegate {

        var webView: WKWebView!
        @IBOutlet weak var loginButton: UIButton!
        @IBOutlet weak var usernameTextField: UITextField!
        @IBOutlet weak var passTextField: UITextField!

        override func loadView() {
            let webConfiguration = WKWebViewConfiguration()
            webView = WKWebView(frame: .zero, configuration: webConfiguration)
            webView.uiDelegate = self
            view = webView
        }
        
        override func viewDidLoad() {

            super.viewDidLoad()

            let myURL = URL(string: "https://www.strava.com/oauth/authorize?client_id=23189&response_type=code&redirect_uri=http://localhost:9090&scope=write&state=mystate&approval_prompt=force")
            let myRequest = URLRequest(url: myURL!)
            webView.load(myRequest)
        }
    
    @IBAction func didTapStrava(sender: AnyObject) {
        print("did tap strava")
        let oauthswift = OAuth2Swift(
            consumerKey:    "23426",
            consumerSecret: "0904fa1a2eeff05ab70dcbf642d935f472bbf8ee",        // No secret required
            authorizeUrl:   "https://www.strava.com/oauth/authorize",
            accessTokenUrl: "https://www.strava.com/oauth/token",
            responseType:   "code"
        )
        
        oauthswift.allowMissingStateCheck = true
        //2
        oauthswift.authorizeURLHandler = SafariURLHandler(viewController: self, oauthSwift: oauthswift)

        
        let handle = oauthswift.authorize(
            withCallbackURL: URL(string: "RunningMates://localhost:9090")!,
            scope: "write", state:"mystate",
            success: { credential, response, parameters in
                print("response token: ")

                print(credential.oauthToken)
                // Do your request
        },
            failure: { error in
                print(error.localizedDescription)
            }
        )
    }

    @IBAction func tryLogin(_ sender: UIButton) {
        var username = usernameTextField.text;
        var pass = passTextField.text;
        
        // try to save username and password to mongoDb
    }
        
}



