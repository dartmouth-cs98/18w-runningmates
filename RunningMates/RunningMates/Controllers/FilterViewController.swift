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
   
    let ageSlide = RangeSlider(frame: CGRect.zero)
//    let paceSlide = RangeSlider(frame: CGRect.zero)
//    let proxSlide = RangeSlider(frame: CGRect.zero)

    @IBOutlet weak var minAgeSelected: UITextField!
    @IBOutlet weak var maxAgeSelected: UITextField!
    
   // @IBOutlet weak var fuckUXcode: RangeSlider!
    
    var genderPref = ""
    @IBOutlet weak var femaleButton: DLRadioButton!
    var femaleButtonSwitch = 1
    // MARK: Properties
    @IBOutlet weak var maleButton: DLRadioButton!
    var maleButtonSwitch = 1

    
    //@IBOutlet weak var nameLabel: UILabel!
    
  //  @IBOutlet weak var genderLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(ageSlide)
//        view.addSubview(paceSlide)
//        view.addSubview(proxSlide)

        ageSlide.addTarget(self, action: #selector(FilterViewController.ageSliderValueChanged), for: .valueChanged)
        
//        paceSlide.addTarget(self, action: Selector(("paceSliderValueChanged:")), for: .valueChanged)
//        proxSlide.addTarget(self, action: Selector(("paceSliderValueChanged:")), for: .valueChanged)

            }
    
    @IBAction func savePrefs(_ sender: Any) {
        if (femaleButton.isSelected && maleButton.isSelected) {
            genderPref = "All"
        }
        else if (femaleButton.isSelected) {
            genderPref = "female"
        }
        else if (maleButton.isSelected) {
            genderPref = "male"
        }
        else {
            print("You must select a gender preference.")
        }
        print(genderPref)
        
    }
    
    override func viewDidLayoutSubviews() {
        let margin: CGFloat = 20.0
        let width = view.bounds.width - 2.0 * margin
        ageSlide.frame = CGRect(x: margin, y: 250.0 + topLayoutGuide.length,
                                   width: width, height: 31.0)
        //paceSlide.frame = CGRect(x: margin, y: 375.0 + topLayoutGuide.length,
         //                       width: width, height: 31.0)
       // proxSlide.frame = CGRect(x: margin, y: 500.0 + topLayoutGuide.length,
           //                      width: width, height: 31.0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Actions
//    func rangeSliderValueChanged(rangeSlider: RangeSlider) {
//        print("Range slider value changed: (\(rangeSlider.lowerValue) \(rangeSlider.upperValue))")
//    }
//
    @objc func rangeSliderValueChanged(rangeSlider: RangeSlider) {
        print("Range slider value changed: (\(rangeSlider.lowerValue) \(rangeSlider.upperValue))")
    }
    @objc func ageSliderValueChanged(rangeSlider: RangeSlider) {
        print("Age slider value changed: (\(ageSlide.lowerValue) \(ageSlide.upperValue))")
        self.minAgeSelected.text = String(Int(round(ageSlide.lowerValue)));
        self.maxAgeSelected.text = String(Int(round(ageSlide.upperValue)));
        
    }
    
    @IBAction func maleButtonSelected(_ sender: Any) {
        maleButtonSwitch = maleButtonSwitch * -1;
        if maleButtonSwitch > 0{
            maleButton.isSelected = false
        }else{
            maleButton.isSelected = true
        }
    }
    
    @IBAction func femaleButtonSelected(_ sender: Any) {

        femaleButtonSwitch = femaleButtonSwitch * -1;
        if femaleButtonSwitch > 0{
            femaleButton.isSelected = false
        }else{
            femaleButton.isSelected = true
        }
    }
    
    

    
}
