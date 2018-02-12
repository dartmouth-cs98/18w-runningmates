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
        //        if let url = NSURL(string: "https://www.strava.com/oauth/authorize?client_id=23189&response_type=code&redirect_uri=https://localhost:9090&scope=write&state=mystate&approval_prompt=force"){
//            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
//        }
        
        //1
        print("did tap strava")
        let oauthswift = OAuth2Swift(
            consumerKey:    "23202",
            consumerSecret: "44397e262d39065e316b57b70a43abd5edf75a96",        // No secret required
            authorizeUrl:   "https://www.strava.com/oauth/authorize",
            accessTokenUrl: "https://www.strava.com/oauth/token",
            responseType:   "code"
        )
        print(oauthswift)
        
        oauthswift.allowMissingStateCheck = true
        //2
        oauthswift.authorizeURLHandler = SafariURLHandler(viewController: self, oauthSwift: oauthswift)

        
        let handle = oauthswift.authorize(
            withCallbackURL: URL(string: "RunningMates://localhost:9090")!,
            scope: "write", state:"mystate",
            success: { credential, response, parameters in
                print(credential.oauthToken)
                print("im here")
                // Do your request
        },
            failure: { error in
                print(error.localizedDescription)
        }
        )
        print("heree")

    
        
    }
    

}



