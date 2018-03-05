//
//  UserModel.swift
//  OAuthSwift
//
//  Created by Sudikoff Lab iMac on 2/15/18.
//  Copyright © 2018 Dongri Jin. All rights reserved.
//

import Foundation

class User {
    var firstName: String
    var lastName: String
    var imageURL: String
    var bio: String
    var gender: String
    var age: Int
    var location: [Float]
    var swipes: [String: Int]?
    var mates: [Any]?
    var potentialMates: [Any]?
    var blockedMates: [Any]?
    var seenProfiles: [Any]?
    var email: String
    var password: String
    var token: String?
    var preferences: Any?
    var data: Any?
    

    //MARK: Initialization
    init(firstName: String, lastName: String, imageURL: String, bio: String, gender: String, age: Int, location: [Float], swipes: [String: Int], mates: [Any], potentialMates: [Any], blockedMates: [Any], seenProfiles: [Any], email: String, password: String, token: String, preferences: Any, data: Any) {
        self.firstName = firstName
        self.lastName = lastName
        self.imageURL = imageURL
        self.bio = bio
        self.gender = gender
        self.age = age
        self.location = location
        self.swipes = swipes
        self.mates = mates
        self.potentialMates = potentialMates
        self.seenProfiles = seenProfiles
        self.blockedMates = blockedMates
        self.email = email
        self.password = password
        self.token = token
        self.preferences = preferences
        self.data = data
    }
    
    //JSON initializer
    // https://developer.apple.com/swift/blog/?id=37
    init?(json: [String: Any]) {
        print("json:")
        print(json)
 
        let firstName = json["firstName"] as! String?
            let lastName = json["lastName"] as! String?
            let imageURL = json["imageURL"] as! String?
            let bio = json["bio"] as! String?
            let gender = json["gender"] as! String?
            let age = json["age"] as! Int?
            let location = json["location"] as! [Float]?
            let swipes = json["swipes"] as! [String: Int]?
            let mates = json["mates"] as! [Any]?
            let potentialMates = json["potentialMates"] as! [Any]?
            let seenProfiles = json["seenProfiles"] as! [Any]?
            let blockedMates = json["blockedMates"] as! [Any]?
            let email = json["email"] as! String?
            let password = json["password"] as! String?
            let token = json["token"] as! String?
            let preferences = json["preferences"] as! Any?
            let data = json["data"] as! Any?

        self.firstName = firstName!
        self.lastName = lastName!
        self.imageURL = imageURL!
        self.bio = bio!
        self.gender = gender!
        self.age = age!
        self.location = location!
        self.swipes = swipes
        self.mates = mates
        self.potentialMates = potentialMates
        self.seenProfiles = seenProfiles
        self.blockedMates = blockedMates
        self.email = email!
        self.password = password!
        self.token = token
        self.preferences = preferences
        self.data = data
    }
    
}
