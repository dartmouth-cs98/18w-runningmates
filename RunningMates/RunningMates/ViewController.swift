//
//  ViewController.swift
//  RunningMates
//
//  Created by Sara Topic on 30/01/2018.
//  Copyright © 2018 Apple Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    
    @IBAction func didTapStrava(sender: AnyObject) {
        if let url = NSURL(string: "https://www.strava.com/oauth/authorize?client_id=23189&response_type=code&redirect_uri=https://RunningMates&scope=write&state=mystate&approval_prompt=force"){
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
    }


}

