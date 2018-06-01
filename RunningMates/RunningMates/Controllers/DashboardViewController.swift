//
//  DashboardViewController.swift
//  RunningMates
//
//  Created by Sara Topic on 26/04/2018.
//  Copyright © 2018 Apple Inc. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var infoView: UIView!
    
    @IBOutlet weak var profPic: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var safetrackButton: UIButton!
    
    @IBOutlet weak var metricCirc2: UIView!
    @IBOutlet weak var metricCirc: UIView!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var runsWkLabel: UILabel!
    @IBOutlet weak var milesWkLabel: UILabel!
    
    @IBOutlet weak var bioTextView: UITextView!
    
    override func viewDidLoad() {

        super.viewDidLoad()
     
        //https://www.appcoda.com/ios-programming-circular-image-calayer/
        self.profPic.layer.cornerRadius = self.profPic.frame.size.width / 2;
        self.profPic.clipsToBounds = true;
        self.profPic.layer.borderWidth = 2.5;
        self.profPic.layer.borderColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).cgColor
        
        self.metricCirc.layer.cornerRadius = self.metricCirc.frame.size.width / 2;
        self.metricCirc.clipsToBounds = true;
        self.metricCirc.layer.borderWidth = 1.5;
        self.metricCirc.layer.borderColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).cgColor
        
        self.metricCirc2.layer.cornerRadius = self.metricCirc2.frame.size.width / 2;
        self.metricCirc2.clipsToBounds = true;
        self.metricCirc2.layer.borderWidth = 1.5;
        self.metricCirc2.layer.borderColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).cgColor
        
//        if (UserDefaults.standard.string(forKey: "firstName") != nil) {
        self.name.text = UserDefaults.standard.string(forKey: "firstName")!
        
        if let userImages = UserDefaults.standard.stringArray(forKey: "images"){
            if (userImages.count > 0) {
                let url = URL(string: userImages[0] as! String)


                if let photoData = try? Data(contentsOf: url!) {
                    let image = UIImage(data: photoData)
                    self.profPic.image = image!
                }
            }

        }
       
        //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        
        
        
//        var data: [String: Any] = UserDefaults.standard.value(forKey: "data") as! [String : Any]
        
        setDataTextFields()
        self.navigationController?.navigationBar.tintColor =  UIColor(red:255.0/255.0, green:196.0/255.0, blue:46.0/255.0, alpha:1.0)

//        if (UserDefaults.standard.string(forKey: "bio") != nil) {
//            self.bioTextView.text = UserDefaults.standard.string(forKey: "bio")!
//        }
//        let userImages = UserDefaults.standard.stringArray(forKey: "images")
//        let url = URL(string: userImages![0] as! String)
//        let photoData = try? Data(contentsOf: url!)
//        let image = UIImage(data: photoData!)
//        //self.view.backgroundColor = UIColor(patternImage: image!)
//        self.view.layer.contents = image?.cgImage
//
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        view.addSubview(infoView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if (UserDefaults.standard.string(forKey: "firstName") != nil) {
            self.name.text = UserDefaults.standard.string(forKey: "firstName")!
        }
        setDataTextFields()
        if (UserDefaults.standard.string(forKey: "bio") != nil) {
            self.bioTextView.text = UserDefaults.standard.string(forKey: "bio")!
        }
    }
    
    func setDataTextFields() {
        if (UserDefaults.standard.value(forKey: "data") != nil) {
//            var defaultData: Data = UserDefaults.standard.value(forKey: "data") as! Data
//            if var data : [String:Any] = NSKeyedUnarchiver.unarchiveObject(with: defaultData) as! [String:Any] {
            if let data = UserDefaults.standard.value(forKey: "data") as? [String:Any] {
                if (data["milesPerWeek"] != nil) {
                    self.milesWkLabel.text = String(describing: data["milesPerWeek"]!)
                }
                
                if (data["runsPerWeek"] != nil) {
                    
                    self.runsWkLabel.text = String(describing: data["runsPerWeek"]!)
                }
            }
          
        }
    }
    
}
