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
}





  //  @IBAction func didTapStrava(sender: AnyObject) {
//        if let url = NSURL(string: "https://www.strava.com/oauth/authorize?client_id=23189&response_type=code&redirect_uri=http://localhost:9090&scope=write&state=mystate&approval_prompt=force"){
//            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
//            print("my url", url);

       // }
//        print("here")
//        let Url = String(format: "https://www.strava.com/oauth/authorize")
//        guard let serviceUrl = URL(string: Url) else { return }
//        //        let loginParams = String(format: LOGIN_PARAMETERS1, "test", "Hi World")
//        let parameterDictionary = ["client_id" : "23189", "response_type" : "code", "redirect_uri" : "http://localhost:9090", "scope" : "write", "state" : "mystate", "approval_prompt": "force" ]
//        var request = URLRequest(url: serviceUrl)
//        request.httpMethod = "POST"
//        print("here 1")
//
//        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
//        print("here 2")
//
//        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options: []) else {
//            return
//        }
//        request.httpBody = httpBody
//
//        let session = URLSession.shared
//        session.dataTask(with: request) { (data, response, error) in
//            if let response = response {
//                print("i am here")
//                print(response)
//            }
//            if let data = data {
//                do {
//                    print(response)
//                    //let json = try JSONSerialization.jsonObject(with: data, options: [])
//                    //print([json])
//                }catch {
//                    print(error)
//                }
//            }
//            }.resume()
//
//    }

//}

