//
//  FilterViewController.swift
//  RunningMates
//
//  Created by Sara Topic on 30/01/2018.
//  Copyright © 2018 Apple Inc. All rights reserved.
//
import UIKit
import DLRadioButton
import Alamofire


class FilterViewController: UIViewController, UINavigationControllerDelegate {

   
     let ageSlide = RangeSlider(frame: CGRect.zero)
     let distSlide = RangeSlider(frame: CGRect.zero)
     let proxSlide = RangeSlider(frame: CGRect.zero)
    
    var userEmail: String = ""
    var rootUrl: String = ""

    @IBOutlet weak var minAgeSelected: UITextField!
    @IBOutlet weak var maxAgeSelected: UITextField!
    
    @IBOutlet weak var minDistSelected: UITextField!
    @IBOutlet weak var maxDistSelected: UITextField!
    
    @IBOutlet weak var femaleLabel: UILabel!
    @IBOutlet weak var maleLabel: UILabel!
    @IBOutlet weak var nonBinaryLabel: UILabel!

    @IBOutlet weak var femaleButton: DLRadioButton!
    @IBOutlet weak var maleButton: DLRadioButton!
    @IBOutlet weak var nonBinaryButton: DLRadioButton!

    var femaleButtonSwitch = 1
    var maleButtonSwitch = 1
    var nonBinaryButtonSwitch = 1
    
    var genderPref = [String]()
    var userPref: [String: Any]?
    @IBOutlet weak var maxProximitySelected: UITextField!
    
    @IBOutlet weak var mileageBox: UIView!
    @IBOutlet weak var distanceBox: UIView!
    @IBOutlet weak var ageBox: UIView!
    
    @IBOutlet weak var ageSelectedLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var mileageLabel: UILabel!

    var presentedBy: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.femaleButton.layer.cornerRadius = 15
        self.maleButton.layer.cornerRadius = 15
        self.nonBinaryButton.layer.cornerRadius = 15
        self.ageBox.layer.cornerRadius = 15
        self.distanceBox.layer.cornerRadius = 15
        self.mileageBox.layer.cornerRadius = 15
        
        self.femaleButton.layer.masksToBounds = true
        self.maleButton.layer.masksToBounds = true
        self.nonBinaryButton.layer.masksToBounds = true
        self.ageBox.layer.masksToBounds = true
        self.distanceBox.layer.masksToBounds = true
        self.mileageBox.layer.masksToBounds = true


        
        view.addSubview(ageSlide)
        view.addSubview(distSlide)
        view.addSubview(proxSlide)

        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        self.userEmail = appDelegate.userEmail
        self.userEmail = UserDefaults.standard.value(forKey: "email") as! String
        self.rootUrl = appDelegate.rootUrl
        
        ageSlide.addTarget(self, action: #selector(FilterViewController.ageSliderValueChanged), for: .valueChanged)
        distSlide.addTarget(self, action: #selector(FilterViewController.distSliderValueChanged), for: .valueChanged)
        
        proxSlide.addTarget(self, action: #selector(FilterViewController.proxSliderValueChanged), for: .valueChanged)
        
        ageSlide.configRangeSlider(id: 1)
        distSlide.configRangeSlider(id: 2)
        proxSlide.configRangeSlider(id: 3)
        
        if var currPref = UserDefaults.standard.value(forKey: "preferences") as? [String : Any] {
            let userGenderPref = currPref["gender"] as! [String]
            let userRunLengthPref = (currPref["runLength"] as! [Any])
            let runLengthLower = (userRunLengthPref[0])
            let runLengthUpper = (userRunLengthPref[1])
            let userAgePref = currPref["age"] as! [Any]
            
            
            let ageLower = (userAgePref[0])
            print(ageLower, "ARE LOWER")
            let ageUpper = (userAgePref[1])
     
            if userGenderPref.contains("Female") {
                self.femaleButton.isSelected = true
                self.femaleLabel.textColor = UIColor(red:255.0/255.0, green:196.0/255.0, blue:46.0/255.0, alpha:1.0)
            }
            if userGenderPref.contains("Male") {
                self.maleButton.isSelected = true
                self.maleLabel.textColor = UIColor(red:255.0/255.0, green:196.0/255.0, blue:46.0/255.0, alpha:1.0)
            }
            if userGenderPref.contains("Non-Binary") {
                self.nonBinaryButton.isSelected = true
                self.nonBinaryLabel.textColor = UIColor(red:255.0/255.0, green:196.0/255.0, blue:46.0/255.0, alpha:1.0)
            }
            
            //make sure the input is in range of our sliders
        
            ageSlide.lowerValue = (ageLower as AnyObject).doubleValue
            ageSlide.upperValue = (ageUpper as AnyObject).doubleValue
            
        
            if (ageSlide.upperValue > 99){
                ageSlide.upperValue = 99
            }
            
            if (ageSlide.lowerValue < 18){
                ageSlide.lowerValue = 18
            }
            
            distSlide.lowerValue = (runLengthLower as AnyObject).doubleValue
            distSlide.upperValue = (runLengthUpper as AnyObject).doubleValue

            if (distSlide.upperValue > 25){
                distSlide.upperValue = 25
            }
            if (distSlide.lowerValue < 0){
                distSlide.lowerValue = 0
            }
            
            
            var userMetersProx = currPref["proximity"] as! Double
            let userMilesProx = (userMetersProx * 0.000621371192)
            userMetersProx = userMilesProx * 1609.344
        
            proxSlide.upperValue = userMilesProx
            
            if (proxSlide.upperValue > 25){
                proxSlide.upperValue = 25
            }
            if (proxSlide.upperValue < 0){
                proxSlide.upperValue = 25
            }
            
            
            self.userPref = currPref
        }
        }
    
       func savePrefs() {
        if (femaleButton.isSelected && maleButton.isSelected && nonBinaryButton.isSelected) {
            genderPref = ["Female", "Male", "Non-Binary"]
        }
        else if (femaleButton.isSelected && maleButton.isSelected) {
            genderPref = ["Female", "Male"]
        }
        else if (femaleButton.isSelected && nonBinaryButton.isSelected) {
            genderPref = ["Female", "Non-Binary"]
        }
        else if (maleButton.isSelected && nonBinaryButton.isSelected) {
            genderPref = ["Male", "Non-Binary"]
        }
        else if (maleButton.isSelected) {
            genderPref = ["Male"]
        }
        else if (femaleButton.isSelected) {
            genderPref = ["Female"]
        }
        else if (nonBinaryButton.isSelected) {
            genderPref = ["Non-Binary"]
        }
        else {
            print("You must select a gender preference.")
        }

        
        let runLength = [Double(distSlide.lowerValue), Double(distSlide.upperValue)]
        let age = [Double(ageSlide.lowerValue), Double(ageSlide.upperValue)]
        let proximity = proxSlide.upperValue
    
        var preferences = [String:Any]()
        
        preferences["gender"] = genderPref
        preferences["runLength"] = runLength as [Double]
        preferences["age"] = age
        preferences["proximity"] = proximity * 1609.344 as Double // Meters

        // alamofire request
        let params: [String: Any] = [
            "preferences": preferences,
        ]
        
        UserManager.instance.requestUserUpdate(userEmail: self.userEmail, params: params, completion: {(title, msg) in
                UserDefaults.standard.set(preferences, forKey: "preferences")

            })
    }
    
    override func viewDidLayoutSubviews() {
        let margin: CGFloat = 20.0
        let width = view.bounds.width - 2.0 * margin
        ageSlide.frame = CGRect(x: margin, y: self.ageBox.frame.origin.y + 30,
                                   width: width, height: 30)
        
        proxSlide.frame = CGRect(x: margin, y: self.distanceBox.frame.origin.y + 30, width: width, height: 30.0)
        
       distSlide.frame = CGRect(x: margin, y: self.mileageBox.frame.origin.y + 30, width: width, height: 30.0)
        
      
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    @objc func ageSliderValueChanged(rangeSlider: RangeSlider) {
        print(ageSlide.minimumValue)
        let lowAge = String(Int(round(ageSlide.lowerValue)));
        let highAge = String(Int(round(ageSlide.upperValue)));
        ageSelectedLabel.text = "Between " + lowAge
        + " and " + highAge
    }
    
    
    @objc func distSliderValueChanged(rangeSlider: RangeSlider) {
        
       //https://stackoverflow.com/questions/28447732/checking-if-a-double-value-is-an-integer-swift
        let roundMin = round(distSlide.lowerValue/0.5)*0.5
        let minIsInteger = roundMin.truncatingRemainder(dividingBy: 1.0) == 0.0
       
        var selectedMin = "";
        if (minIsInteger){
           selectedMin = String(Int(roundMin))
        }
        else{
            selectedMin = String(roundMin)

        }

        let roundMax = round(distSlide.upperValue/0.5)*0.5
        let maxIsInteger = roundMax.truncatingRemainder(dividingBy: 1.0) == 0.0
        var selectedMax = "";

        if (maxIsInteger){
            selectedMax = String(Int(roundMax))
        }
        else{
           selectedMax = String(roundMax)
        }
        mileageLabel.text = "Between " + selectedMin + " and " + selectedMax + " miles"
        
    }
    
    @objc func proxSliderValueChanged(rangeSlider: RangeSlider) {
                distanceLabel.text = "Up to " + String(Int(proxSlide.upperValue)) + " miles away"
        
    }
    
    @IBAction func maleButtonSelected(_ sender: Any) {
        maleButtonSwitch = maleButtonSwitch * -1;
        if maleButtonSwitch > 0{
            maleButton.isSelected = false
            maleLabel.textColor = UIColor.black

        }else{
            maleButton.isSelected = true
            maleLabel.textColor = UIColor(red:255.0/255.0, green: 196.0/255.0, blue:46.0/255.0, alpha:1.0)
            
        }
    }
    
    @IBAction func femaleButtonSelected(_ sender: Any) {

        femaleButtonSwitch = femaleButtonSwitch * -1;
        if femaleButtonSwitch > 0{
            femaleButton.isSelected = false
            femaleLabel.textColor = UIColor.black
        }else{
            femaleButton.isSelected = true
            femaleLabel.textColor = UIColor(red:255.0/255.0, green: 196.0/255.0, blue:46.0/255.0, alpha:1.0)
            
        }
    }
    
    @IBAction func nonBinaryButtonSelected(_ sender: Any) {
        print("nonbinary button selected")
        nonBinaryButtonSwitch = nonBinaryButtonSwitch * -1;
        if nonBinaryButtonSwitch > 0{
            nonBinaryButton.isSelected = false
            nonBinaryLabel.textColor = UIColor.black

        }else{
            nonBinaryButton.isSelected = true
            nonBinaryLabel.textColor = UIColor(red:255.0/255.0, green:196/255.0, blue:46.0/255.0, alpha:1.0)
        }
    }
    
    
    @IBAction func cancelPressed(_ sender: UIButton) {
//         let  vc = self.storyboard?.instantiateViewController(withIdentifier: "Matching") as! UINavigationController
//        self.present(vc, animated: true, completion: nil)
        //self.navigationController?.dismiss(animated: true)
        self.dismiss(animated: true, completion: nil)
        // self.navigationController?.popToRootViewController(animated: true)

  
        
    }
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        savePrefs()
     
//            let  vc = self.storyboard?.instantiateViewController(withIdentifier: "Matching") as! UINavigationController
//            self.present(vc, animated: true, completion: nil)
        //self.navigationController?.dismiss(animated: true)
        self.dismiss(animated: true, completion: nil)
        // self.navigationController?.popToRootViewController(animated: true)

    }
}
