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
    @IBOutlet weak var segment2: UILabel!
    @IBOutlet weak var segment3: UILabel!
    @IBOutlet weak var segment4: UILabel!
    @IBOutlet weak var segment5: UILabel!
    @IBOutlet weak var distance1: UILabel!
    @IBOutlet weak var distance2: UILabel!
    @IBOutlet weak var distance3: UILabel!
    @IBOutlet weak var distance4: UILabel!
    @IBOutlet weak var distance5: UILabel!
    @IBOutlet weak var name4Segment: UILabel!
    @IBOutlet weak var yourTime1: UILabel!
    @IBOutlet weak var yourTime2: UILabel!
    @IBOutlet weak var yourTime3: UILabel!
    @IBOutlet weak var yourTime4: UILabel!
    @IBOutlet weak var yourTime5: UILabel!
    @IBOutlet weak var theriTime1: UILabel!
    @IBOutlet weak var theriTime2: UILabel!
    @IBOutlet weak var theriTime3: UILabel!
    @IBOutlet weak var theriTime4: UILabel!
    @IBOutlet weak var theriTime5: UILabel!
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
        self.loadingView.center = self.view.center
        loadingView.progressIndicator.startAnimating()
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
        name4Segment.text = user.firstName!
        locationLabel.text = distance!
        bioLabel.text = user.bio
        
        if (data!["milesPerWeek"] != nil) {
            milesPerWeek.text = String(describing: data!["milesPerWeek"]!) + " mi/week"
        } else {
            milesPerWeek.text = ""
            milesPerWeek.removeFromSuperview()
        }
        if (data!["runsPerWeek"] != nil) {
            runsPerWeek.text = (String(describing: data!["runsPerWeek"]!) + " runs/week")
    
        } else {
            runsPerWeek.text = ""
            runsPerWeek.removeFromSuperview()
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
        var segmentsArray = [segment!]()
        
        UserManager.instance.sendMatchingSegmentRequest(userId: userId!, targetId: user.id!, completion: { list in
            segmentsArray = list
            
            if (segmentsArray.indices.contains(0)){
                self.segments.text = segmentsArray[0].title
                self.distance1.text = (String(format: "%.1f", segmentsArray[0].distance) + "mi")
                self.yourTime1.text = segmentsArray[0].userTime
                self.theriTime1.text = segmentsArray[0].targetTime
            } else {
                self.segments.text = ""
                self.distance1.text = ""
                self.yourTime1.text = ""
                self.theriTime1.text = ""
                
            }


            if (segmentsArray.indices.contains(1)){
                self.segment2.text = segmentsArray[1].title
                self.distance2.text = (String(format: "%.1f", segmentsArray[1].distance) + "mi")
                self.yourTime2.text = segmentsArray[1].userTime
                self.theriTime2.text = segmentsArray[1].targetTime
            } else {
                self.segment2.text = ""
                self.distance2.text = ""
                self.yourTime2.text = ""
                self.theriTime2.text = ""
            }

            if (segmentsArray.indices.contains(2)){
                self.segment3.text = segmentsArray[2].title
                self.distance3.text = (String(format: "%.1f", segmentsArray[2].distance) + "mi")
                self.yourTime3.text = segmentsArray[2].userTime
                self.theriTime3.text = segmentsArray[2].targetTime
            } else {
                self.segment3.text = ""
                self.distance3.text = ""
                self.yourTime3.text = ""
                self.theriTime3.text = ""
            }

            if (segmentsArray.indices.contains(3)){
                self.segment4.text = segmentsArray[3].title
                self.distance4.text = (String(format: "%.1f", segmentsArray[3].distance) + "mi")
                self.yourTime4.text = segmentsArray[3].userTime
                self.theriTime4.text = segmentsArray[3].targetTime
            } else {
                self.segment4.text = ""
                self.distance4.text = ""
                self.yourTime4.text = ""
                self.theriTime4.text = ""
            }

            if (segmentsArray.indices.contains(4)){
                self.segment5.text = segmentsArray[4].title
                self.distance5.text = (String(format: "%.1f", segmentsArray[4].distance) + "mi")
                self.yourTime5.text = segmentsArray[4].userTime
                self.theriTime5.text = segmentsArray[4].targetTime
            } else {
                self.segment5.text = ""
                self.distance5.text = ""
                self.yourTime5.text = ""
                self.theriTime5.text = ""
            }
        })
        

        
        
        
        
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
