//
//  ViewController.swift
//  FoodTracker
//
//  Created by Divya Kalidindi on 2/15/18.
//  Copyright © 2018 Divya Kalidindi. All rights reserved.
//

import UIKit

class MatchingViewController: UIViewController, UIGestureRecognizerDelegate {
   
   // MARK: Properties
   
    @IBOutlet weak var nameLabel: UILabel!
    var current_index = 0
    
    let myUser1 = User.init(firstName: "Drew", lastName: "Waterman", imageURL: "url", bio: "drew_bio", gender: "female", age: 21, location: "iowa", email: "email@email.com", username: "drew_username", password: "password", token: "token")
    
    let myUser2 = User.init(firstName: "Divya", lastName: "Kalidindi", imageURL: "url", bio: "divya_bio", gender: "female", age: 21, location: "california", email: "email@email.com", username: "divya_username", password: "password", token: "token")
    
    let myUser3 = User.init(firstName: "Brian", lastName: "Francis", imageURL: "url", bio: "brian_bio", gender: "male", age: 21, location: "california", email: "email@email.com", username: "brian_username", password: "password", token: "token")
    
    let myUser4 = User.init(firstName: "Shea", lastName: "Wojciehowski", imageURL: "url", bio: "shea_bio", gender: "female", age: 21, location: "california", email: "email@email.com", username: "shea_username", password: "password", token: "token")
    
    let myUser5 = User.init(firstName: "Sara", lastName: "Topic", imageURL: "url", bio: "sara_bio", gender: "female", age: 21, location: "california", email: "email@email.com", username: "sara_username", password: "password", token: "token")
    
    let myUser6 = User.init(firstName: "Jon", lastName: "Gonzalez", imageURL: "url", bio: "jon_bio", gender: "male", age: 21, location: "california", email: "email@email.com", username: "jon_username", password: "password", token: "token")
    
    var userList = [User]()
    
    
    override func viewDidLoad() {
       super.viewDidLoad()
       // Do any additional setup after loading the view, typically from a nib.
        
        // https://stackoverflow.com/questions/32855753/i-want-to-swipe-right-and-left-in-swift
        // https://stackoverflow.com/questions/31785755/when-im-using-uiswipegesturerecognizer-im-getting-thread-1signal-sigabrt
        let swipeLeft : UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "swipeNewMatch:")
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        
        let swipeRight : UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "swipeNewMatch:")
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        
        self.view.addGestureRecognizer(swipeLeft)
        self.view.addGestureRecognizer(swipeRight)
        
        userList.append(myUser1)
        userList.append(myUser2)
        userList.append(myUser3)
        userList.append(myUser4)
        userList.append(myUser5)
        userList.append(myUser6)
        
        
        
        nameLabel.text = userList[0].firstName
        
   }

   override func didReceiveMemoryWarning() {
       super.didReceiveMemoryWarning()
       // Dispose of any resources that can be recreated.
   }
   
   //MARK: Actions
    // https://stackoverflow.com/questions/28696008/swipe-back-and-forth-through-array-of-images-swift?rq=1
    @IBAction func swipeNewMatch(_ sender: UISwipeGestureRecognizer) {
        let size = userList.count
        
        switch sender.direction {
        case UISwipeGestureRecognizerDirection.right:
            print("SWIPED right")
            //do nothing if swipe right?
        case UISwipeGestureRecognizerDirection.left:
            print("SWIPED left")
            if (current_index < size-1) {
                current_index = current_index + 1
            }
            else {
                current_index = 0
            }
            nameLabel.text = userList[current_index].firstName
            
        default:
            break
        }
        
    }
    
    @IBAction func matchButton(_ sender: UIButton) {
        
        print("You clicked match.")
        
    }
   
   
}
