//
//  ViewController.swift
//  FoodTracker
//
//  Created by Divya Kalidindi on 2/15/18.
//  Copyright © 2018 Divya Kalidindi. All rights reserved.
//

import UIKit

class MatchingViewController: UIViewController {
   
   // MARK: Properties
   
    @IBOutlet weak var nameLabel: UILabel!
    
    
    override func viewDidLoad() {
       super.viewDidLoad()
       // Do any additional setup after loading the view, typically from a nib.
   }

   override func didReceiveMemoryWarning() {
       super.didReceiveMemoryWarning()
       // Dispose of any resources that can be recreated.
   }
   
   //MARK: Actions

    @IBAction func matchButton(_ sender: UIButton) {
        
        nameLabel.text = "Divya Kalidindi"
    }
   
   
}