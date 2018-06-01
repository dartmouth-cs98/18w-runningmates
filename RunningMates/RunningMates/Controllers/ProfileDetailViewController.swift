//
//  ProfileDetailViewController.swift
//  RunningMates
//
//  Created by dali on 5/29/18.
//  Copyright © 2018 Apple Inc. All rights reserved.
//

import Foundation
import UIKit

class ProfileDetailViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var profImage: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var totalMilesLabel: UILabel!
    @IBOutlet weak var averageRunLengthLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet var topView: UIView!
    @IBOutlet weak var milesPerWeek: UILabel!
    @IBOutlet weak var runsPerWeek: UILabel!
    @IBOutlet weak var racesDone: UILabel!
    @IBOutlet weak var totalElevation: UILabel!
    @IBOutlet weak var matchReason: UILabel!
    @IBOutlet weak var matchButton: UIButton!
    @IBOutlet weak var segments: UILabel!
    @IBOutlet weak var stravaImage: UIImageView!
    @IBOutlet weak var verifiedImage: UIImageView!
    
    var userList = [sortedUser]()
    var index: Int!
    var distance: String!
    var currentUser: User!
    var loadingView: ProfileLoadingView!
    var userId: String! = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        loadingView = ProfileLoadingView().fromNib() as! ProfileLoadingView
        topView.addSubview(loadingView)
        loadingView.progressIndicator.startAnimating()
        print("showing loading view")
        
        stravaImage.isHidden = true
        verifiedImage.isHidden = true
        
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        
//        self.profImage.layer.frame.size.width = 140
//        self.profImage.layer.frame.size.height = 140

        self.profImage.layer.cornerRadius = 80;
        self.profImage.clipsToBounds = true;
        
        self.userId = UserDefaults.standard.string(forKey: "id")!
        print(self.profImage.layer.frame.size.width)
        print(self.profImage.layer.frame.size.height)
        print(self.profImage.frame.size.width)
        print(self.profImage.frame.size.height)

    
 
        //super.viewDidAppear(animated)
        
        // get list of potential matches, and find the one they clicked
        userList = UserManager.instance.userList
        index = UserDefaults.standard.value(forKey: "clickedUserIndex") as! Int
        distance = UserDefaults.standard.value(forKey: "distanceAway") as! String
        
        currentUser = userList[index].user
        if (currentUser != nil) {
            loadDataForUser(user: currentUser)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func loadDataForUser(user: User) {
        var data = user.data
        
        nameLabel.text = user.firstName! + ", " + String(user.age)
        locationLabel.text = distance!
        bioLabel.text = user.bio
        
        if (data!["milesPerWeek"] != nil) {
            milesPerWeek.text = String(describing: data!["milesPerWeek"]!) + " mi/week"
        } else {
            milesPerWeek.text = ""
            milesPerWeek.removeFromSuperview()
        }
        if (data!["runsPerWeek"] != nil) {
            runsPerWeek.text = String(describing: data!["runsPerWeek"]!) + " runs/week"
        } else {
            totalElevation.text = ""
            totalElevation.removeFromSuperview()
        }
        if (data!["totalMilesRun"] != nil) {
            totalMilesLabel.text = String(describing: data!["totalMilesRun"]!) + " total miles"
        } else {
            totalMilesLabel.text = ""
            totalMilesLabel.removeFromSuperview()
        }
        if (data!["totalElevationClimbed"] != nil) {
            totalElevation.text = String(describing: data!["totalElevationClimbed"]!) + " total Elevation (ft)"
        } else {
            totalElevation.text = ""
            totalElevation.removeFromSuperview()
        }
        
        if (userList[index].matchReason != "") {
            matchReason.text = "*" + userList[index].matchReason + "!*"
        }
        
        if ( (user.data!["racesDone"] != nil) && (String(describing: user.data!["racesDone"]!) != "(\n)") ){
            racesDone.text = "Races: " + String(describing: user.data!["racesDone"]!)
                    } else {
            racesDone.removeFromSuperview()
        }
        
        if let images = user.images as? [String] {
            if let url = URL(string: images[0]) {
                let photoData = try? Data(contentsOf: url)
                let image = UIImage(data: photoData!)
                
                self.profImage.image = image
            }
        }
        
        if (user.thirdPartyIds != nil) {
            verifiedImage.isHidden = false
            stravaImage.isHidden = false
        }
        
        segments.text = ""
        var segmentsArray = [segment]()
        
        UserManager.instance.sendMatchingSegmentRequest(userId: userId!, targetId: user.id!, completion: { list in
            segmentsArray = list
        })
        
        print(String(describing: segmentsArray))
        
        if (user.data!["totalMilesRun"] != nil) {
            self.totalMilesLabel.text = ("Total Miles: " + String(describing: userList[index].user.data!["totalMilesRun"]!) + " mi")
        } else {
            self.totalMilesLabel.text = "Total Miles: No info to show"
        }
        
        if (user.data!["averageRunLength"] != nil) {
            self.averageRunLengthLabel.text = ("Avg. Run Length: " + String(describing: userList[index].user.data!["averageRunLength"]!) + " mi")
        } else {
            self.averageRunLengthLabel.text = "Avg. Run Length: No info to show"
        }
        self.loadingView.removeFromSuperview()
    }
   
    @IBAction func onClick(_ sender: Any) {
        UserManager.instance.sendMatchRequest(userId: self.userId, targetId: self.userList[index].user.id!, firstName: self.userList[index].user.firstName!, completion: { title, message in
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "Close", style: .default, handler: nil)
            alertController.addAction(defaultAction)
                        self.present(alertController, animated: true,  completion: nil)

        })
    }
}
