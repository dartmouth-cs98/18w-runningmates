//
//  ProfileDetailViewController.swift
//  RunningMates
//
//  Created by dali on 5/29/18.
//  Copyright © 2018 Apple Inc. All rights reserved.
//

import Foundation
import UIKit

class ProfileDetailViewController: UIViewController {
    
    @IBOutlet weak var profImage: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var totalMilesLabel: UILabel!
    @IBOutlet weak var averageRunLengthLabel: UILabel!
    
    var userList = [sortedUser]()
    var index: Int!
    var distance: String!
    var currentUser: User!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.profImage.layer.cornerRadius = self.profImage.frame.size.width / 2;
        self.profImage.clipsToBounds = true;
        
        // get list of potential matches, and find the one they clicked
        userList = UserDefaults.standard.value(forKey: "userList") as! [sortedUser]
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
        nameLabel.text = user.firstName! + ", " + String(user.age)
        locationLabel.text = distance!
        
        if let images = user.images as? [String] {
            if let url = URL(string: images[0]) {
                let photoData = try? Data(contentsOf: url)
                let image = UIImage(data: photoData!)
                
                self.profImage.image = image
            }
        }
        
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
    }
}
