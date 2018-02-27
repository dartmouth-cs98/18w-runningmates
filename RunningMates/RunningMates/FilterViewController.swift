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
   

    
    // MARK: Properties
    
    @IBOutlet weak var femaleButton: DLRadioButton!
    @IBOutlet weak var maleButton: DLRadioButton!
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
    
        

    @IBAction func didSelectFemale(_ sender: DLRadioButton) {

        print("selected female")
        femaleButton.isSelected = false

        
        
    }
    @IBAction func didSelectMale(_ sender: Any) {
        print("selected male")
        if let button = sender as? UIButton {
            if button.isSelected {
                // set deselected
                button.isSelected = false
            } else {
                // set selected
                button.isSelected = true
            }
        }
    }
    
    //@IBAction func matchButton(_ sender: UIButton) {
        
      //  nameLabel.text = "Divya Kalidindi"
    //}
    //        addSubview(matchingView)
    
}
