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
    let paceSlide = RangeSlider(frame: CGRect.zero)
    let proxSlide = RangeSlider(frame: CGRect.zero)
    
//    var rootURl: String = "http://localhost:9090/"
    var rootURl: String = "https://running-mates.herokuapp.com/"
    
    var userEmail = ""
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    
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
        view.addSubview(paceSlide)
        view.addSubview(proxSlide)
        
        self.userEmail = appDelegate.userEmail

        ageSlide.addTarget(self, action: Selector(("ageSliderValueChanged:")), for: .valueChanged)
        paceSlide.addTarget(self, action: Selector(("paceSliderValueChanged:")), for: .valueChanged)
        proxSlide.addTarget(self, action: Selector(("paceSliderValueChanged:")), for: .valueChanged)

            }
    
    @IBAction func savePrefs(_ sender: Any) {

        if (femaleButton.isSelected && maleButton.isSelected) {
            genderPref = "All"
        }
        else if (femaleButton.isSelected) {
            genderPref = "Female"
        }
        else if (maleButton.isSelected) {
            genderPref = "Male"
        }
        else {
            print("You must select a gender preference.")
        }
        print(genderPref)
        

        // alamofire request
        let params: [String: Any] = [
            "email": userEmail,
            "preferences": genderPref
            //hi drew
        ]

        let url = rootURl + "/api/savePrefs"

        
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
        ageSlide.frame = CGRect(x: margin, y: 200.0 + topLayoutGuide.length,
                                   width: width, height: 31.0)
        paceSlide.frame = CGRect(x: margin, y: 375.0 + topLayoutGuide.length,
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
    @IBAction func rangeSliderValueChanged(_ sender: RangeSlider) {
        print("Range slider value changed: (\(ageSlide.lowerValue) \(ageSlide.upperValue))")

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
