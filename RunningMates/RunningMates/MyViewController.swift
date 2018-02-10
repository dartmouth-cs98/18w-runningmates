//
//  MyViewController.swift
//  ihatethis
//
//  Created by Sara Topic on 07/02/2018.
//  Copyright © 2018 Apple Inc. All rights reserved.
//

import UIKit
import WebKit

class MyViewController: UIViewController, WKScriptMessageHandler {
    
    var webView: WKWebView!
    let userContentController = WKUserContentController()
    


    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        let dict = message.body as! [String:AnyObject]
        
    }

    
    override func loadView() {
        super.loadView()
        print("here")
        let config = WKWebViewConfiguration()
        config.userContentController = userContentController
        
        self.webView = WKWebView(frame: self.view.bounds, configuration: config)
        userContentController.add(self, name: "userLogin")
        
        self.view = self.webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        print("here")
        let myURL = URL(string: "https://www.strava.com/oauth/authorize?client_id=23189&response_type=code&redirect_uri=http://localhost:9090&scope=write&state=mystate&approval_prompt=force")
        let myRequest = URLRequest(url: myURL!)

        webView.load(myRequest)

        let Url = String(format: "https://www.strava.com/oauth/authorize")
        guard let serviceUrl = URL(string: Url) else { return }
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"

        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print("i am here")
                print(response)

            }
            
        }
        
        // Do any additional setup after loading the view.
       
    }
    //
    

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
        print("did finish navigation")
    }
    override func viewDidAppear(_ animated: Bool) {
        print("view did appear")
        print(webView.url)
    }
    
    
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        print("HERE", url, navigationAction.request.url)
        decisionHandler(.allow)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webView(webView: WKWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool
    {
        print("called")
        if let URL = request.url?.absoluteString
        {
            // This should be the redirect URL that you pass it can be anything like local host mentioned above.
            if URL.hasPrefix("http://")
            {
                // Now you can simply do some string manipulation to pull out the relevant components.
                // I'm not sure what sort of token or how you get it back but assuming the redirect URL is
                // YourRedirectURL&code=ACCESS_TOKEN and you want access token heres how you would get it.
                var code : String?
                if let URLParams = request.url?.query?.components(separatedBy :"&")
                {
                    for param in URLParams
                    {
                        let keyValue = param.components(separatedBy :"=")
                        let key = keyValue.first
                        if key == "code"
                        {
                            code = keyValue.last
                        }
                    }
                }
                // Here if code != nil then it has the ACCESS_TOKEN and you are done! If its nil something went wrong.
                return false // So that the webview doesnt redirect to the dummy URL you passed.
            }
        }
        return true
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

