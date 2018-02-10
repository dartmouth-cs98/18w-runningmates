//
//  ViewController.swift
//  RunningMates
//
//  Created by Sara Topic on 30/01/2018.
//  Copyright © 2018 Apple Inc. All rights reserved.
//

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

        
        var webView: WKWebView!
   
        @IBAction func didTapStrava(sender: AnyObject) {
            print("holla")
        }
        
        override func loadView() {
            let webConfiguration = WKWebViewConfiguration()
            webView = WKWebView(frame: .zero, configuration: webConfiguration)
            webView.uiDelegate = self
            view = webView
        }
        override func viewDidLoad() {

            super.viewDidLoad()
            print("here")
           // let myURL = URL(string: "https://www.strava.com/oauth/authorize?client_id=23189&response_type=code&redirect_uri=http://localhost:9090&scope=write&state=mystate&approval_prompt=force")
           // let myRequest = URLRequest(url: myURL!)
           // webView.load(myRequest)
        }



}



