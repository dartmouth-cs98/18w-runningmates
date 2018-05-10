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


class FilterViewController: UIViewController {

   
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
    
    var userPref: [String: Any] = UserDefaults.standard.dictionary(forKey: "preferences")!
 

    @IBOutlet weak var maxProximitySelected: UITextField!
    
    @IBOutlet weak var ageBox: UILabel!
    @IBOutlet weak var distanceBox: UILabel!
    @IBOutlet weak var mileageBox: UILabel!

    @IBOutlet weak var ageSelectedLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var mileageLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        self.userEmail = appDelegate.userEmail
        self.rootUrl = appDelegate.rootUrl
        
        ageSlide.addTarget(self, action: #selector(FilterViewController.ageSliderValueChanged), for: .valueChanged)
        distSlide.addTarget(self, action: #selector(FilterViewController.distSliderValueChanged), for: .valueChanged)
        
        proxSlide.addTarget(self, action: #selector(FilterViewController.proxSliderValueChanged), for: .valueChanged)
        
        ageSlide.configRangeSlider(id: 1)
        distSlide.configRangeSlider(id: 2)
        proxSlide.configRangeSlider(id: 3)
        
        if ((self.userPref["gender"] as! [String]).isEmpty == false) {
            let userGenderPref = self.userPref["gender"] as! [String]
            let userRunLengthPref = self.userPref["runLength"] as! [Double]
            let userAgePref = self.userPref["age"] as! [Double]
     
            if userGenderPref.contains("Female") {
                self.femaleButton.isSelected = true
                self.femaleLabel.textColor = UIColor(red:255.0/255.0, green:103/255.0, blue:37.0/255.0, alpha:1.0)
            }
            if userGenderPref.contains("Male") {
                self.maleButton.isSelected = true
                self.maleLabel.textColor = UIColor(red:255.0/255.0, green:103/255.0, blue:37.0/255.0, alpha:1.0)
            }
            if userGenderPref.contains("Non-Binary") {
                self.nonBinaryButton.isSelected = true
                self.nonBinaryLabel.textColor = UIColor(red:255.0/255.0, green:103/255.0, blue:37.0/255.0, alpha:1.0)
            }
        
            ageSlide.lowerValue = userAgePref[0]
            ageSlide.upperValue = userAgePref[1]
        
            distSlide.lowerValue = userRunLengthPref[0]
            distSlide.upperValue = userRunLengthPref[1]

            var userMetersProx = userPref["proximity"] as! Double
            let userMilesProx = (userMetersProx * 0.000621371192)
            userMetersProx = userMilesProx * 1609.344
        
            proxSlide.upperValue = userMilesProx
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
        print(genderPref)
        print("AGE")
        print (ageSlide.lowerValue, ageSlide.upperValue)
        print("DIST")
        print(distSlide.lowerValue, distSlide.upperValue)
        print("Prox")
        print(proxSlide.upperValue)
        
        let runLength = (distSlide.lowerValue, distSlide.upperValue)
        let age = (ageSlide.lowerValue, ageSlide.upperValue)
        let proximity = proxSlide.upperValue
    
        
        // alamofire request
        let params: [String: Any] = [
            "email": self.userEmail,
            "gender": genderPref,
            "runLength": runLength,
            "age": age,
            "proximity": proximity
        ]
        print(params)

        let url = rootUrl + "/api/prefs"

        let _request = Alamofire.request(url, method: .post, parameters: params)
            .responseString { response in
                switch response.result {
                case .success:
                    print("success! response is:")
                    print(response)
                case .failure(let error):
                    print("error fetching users")
                    print(error)
                }
        }
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
        print("roundmax", roundMax, maxIsInteger)

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
            maleLabel.textColor = UIColor(red:255.0/255.0, green:103/255.0, blue:37.0/255.0, alpha:1.0)
            
        }
    }
    
    @IBAction func femaleButtonSelected(_ sender: Any) {

        femaleButtonSwitch = femaleButtonSwitch * -1;
        if femaleButtonSwitch > 0{
            femaleButton.isSelected = false
            femaleLabel.textColor = UIColor.black
        }else{
            femaleButton.isSelected = true
            femaleLabel.textColor = UIColor(red:255.0/255.0, green:103/255.0, blue:37.0/255.0, alpha:1.0)
            
        }
    }
    
    @IBAction func nonBinaryButtonSelected(_ sender: Any) {
        
        nonBinaryButtonSwitch = nonBinaryButtonSwitch * -1;
        if nonBinaryButtonSwitch > 0{
            nonBinaryButton.isSelected = false
            nonBinaryLabel.textColor = UIColor.black

        }else{
            nonBinaryButton.isSelected = true
                    nonBinaryLabel.textColor = UIColor(red:255.0/255.0, green:103/255.0, blue:37.0/255.0, alpha:1.0)
        }
    }
    
    
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        
        let isPresentingInAddContactMode = presentingViewController is UINavigationController
        
            if isPresentingInAddContactMode {
                dismiss(animated: true, completion: nil)
            }
            else if let owningNavigationController = navigationController{
                owningNavigationController.popViewController(animated: true)
            }
            else {
                fatalError("The Emergency Contact View Controller is not inside a navigation controller.")
            }
        
    
        }
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        
        savePrefs()
        
        let isPresentingInAddContactMode = presentingViewController is UINavigationController
        
        if isPresentingInAddContactMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The Emergency Contact View Controller is not inside a navigation controller.")
        }
        
    }
  
}
