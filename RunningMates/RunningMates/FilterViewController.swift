//
//  FilterViewController.swift
//  RunningMates
//
//  Created by Sara Topic on 30/01/2018.
//  Copyright © 2018 Apple Inc. All rights reserved.
//
import UIKit
import DLRadioButton


class FilterViewController: UIViewController {
   

    
    @IBOutlet weak var femaleButton: DLRadioButton!
    var femaleButtonSwitch = 1
    // MARK: Properties
    @IBOutlet weak var maleButton: DLRadioButton!
    var maleButtonSwitch = 1

  
    //@IBOutlet weak var nameLabel: UILabel!
    
  //  @IBOutlet weak var genderLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Actions
    
    @IBAction func maleButtonSelected(_ sender: Any) {
        print("selected male")
        maleButtonSwitch = maleButtonSwitch * -1;
        if maleButtonSwitch > 0{
            maleButton.isSelected = false
        }else{
            maleButton.isSelected = true
        }
    }
    
    @IBAction func femaleButtonSelected(_ sender: Any) {
        print("selected female")
        femaleButtonSwitch = femaleButtonSwitch * -1;
        if femaleButtonSwitch > 0{
            femaleButton.isSelected = false
        }else{
            femaleButton.isSelected = true
        }
    }

    
}
