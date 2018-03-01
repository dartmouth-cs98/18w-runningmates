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
    var email: String
    var username: String
    var password: String
    var token: String

    //MARK: Initialization
    init(firstName: String, lastName: String, imageURL: String, bio: String, gender: String, age: Int, location: [Float], email: String, username: String, password: String, token: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.imageURL = imageURL
        self.bio = bio
        self.gender = gender
        self.age = age
        self.location = location
        self.email = email
        self.username = username
        self.password = password
        self.token = token
    }
    
    //JSON initializer
    // https://developer.apple.com/swift/blog/?id=37
    init?(json: [String: Any]) {
        print("location type:")
 
        let firstName = json["firstName"]! as? String
            let lastName = json["lastName"]! as? String
            let imageURL = json["imageURL"]! as? String
            let bio = json["bio"]! as? String
            let gender = json["gender"]! as? String
            let age = json["age"]! as? Int
            let location = json["location"]! as? [Float]
            let email = json["email"]! as? String
            let username = json["username"]! as? String
            let password = json["password"]! as? String
//            let token = json["token"]! as? String

//            else {
//                return nil
//        }

        self.firstName = firstName!
        self.lastName = lastName!
        self.imageURL = imageURL!
        self.bio = bio!
        self.gender = gender!
        self.age = age!
        self.location = location!
//        self.location = [0,0]
        self.email = email!
        self.username = username!
        self.password = password!
        self.token = ""
    }
    
}
