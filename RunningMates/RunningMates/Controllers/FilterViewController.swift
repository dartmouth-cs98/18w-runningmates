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
    
    var genderPref = ""
    @IBOutlet weak var femaleButton: DLRadioButton!
    var femaleButtonSwitch = 1
    // MARK: Properties
    @IBOutlet weak var maleButton: DLRadioButton!
    var maleButtonSwitch = 1

    @IBOutlet weak var maxProximitySelected: UITextField!
    
    //@IBOutlet weak var nameLabel: UILabel!
    
  //  @IBOutlet weak var genderLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
//        print(genderPref)
//        print("AGE")
//        print (ageSlide.lowerValue, ageSlide.upperValue)
//        print("DIST")
//        print(distSlide.lowerValue, distSlide.upperValue)
//        print("Prox")
//        print(proxSlide.upperValue)
        
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
        ageSlide.frame = CGRect(x: margin, y: 250.0 + topLayoutGuide.length,
                                   width: width, height: 31.0)
        distSlide.frame = CGRect(x: margin, y: 375.0 + topLayoutGuide.length,
                            width: width, height: 31.0)
        proxSlide.frame = CGRect(x: margin, y: 500.0 + topLayoutGuide.length,
                                 width: width, height: 31.0)
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
       // print("Range slider value changed: (\(rangeSlider.lowerValue) \(rangeSlider.upperValue))")
    }
    @objc func ageSliderValueChanged(rangeSlider: RangeSlider) {
//        print("Age slider value changed: (\(ageSlide.lowerValue) \(ageSlide.upperValue))")
        self.minAgeSelected.text = String(Int(round(ageSlide.lowerValue)));
        self.maxAgeSelected.text = String(Int(round(ageSlide.upperValue)));
        
    }
    
    
    @objc func distSliderValueChanged(rangeSlider: RangeSlider) {
//        print("Dist slider value changed: (\(distSlide.lowerValue) \(distSlide.upperValue))")
        
       //https://stackoverflow.com/questions/28447732/checking-if-a-double-value-is-an-integer-swift
        let roundMin = round(distSlide.lowerValue/0.5)*0.5
        let minIsInteger = roundMin.truncatingRemainder(dividingBy: 1.0) == 0.0
        if (minIsInteger){
            self.minDistSelected.text = String(Int(roundMin)) + "mi";

        }
        else{
            self.minDistSelected.text = String(roundMin) + "mi";
        }
        
        let roundMax = round(distSlide.upperValue/0.5)*0.5
        let maxIsInteger = roundMax.truncatingRemainder(dividingBy: 1.0) == 0.0

        if (maxIsInteger){
            self.maxDistSelected.text = String(Int(roundMax)) + "mi";
            
        }
        else{
            self.maxDistSelected.text = String(roundMax) + "mi";
        }
        
    }
    
    @objc func proxSliderValueChanged(rangeSlider: RangeSlider) {
//        print("Prox slider value changed: (\(proxSlide.lowerValue) \(proxSlide.upperValue))")
        
        self.maxProximitySelected.text = String(Int(proxSlide.upperValue)) + "mi"
        
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
