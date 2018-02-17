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

//
//class ViewController: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view, typically from a nib.
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }


    class ViewController: UIViewController, WKUIDelegate {

    
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
    

}



