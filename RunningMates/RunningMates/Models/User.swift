//
//  UserModel.swift
//  OAuthSwift
//
//  Created by Sudikoff Lab iMac on 2/15/18.
//  Copyright © 2018 Dongri Jin. All rights reserved.
//

import UIKit
import os.log

enum UserInitError: Error {
    case invalidId
    case invalidFirstName
    case invalidLastName
    case invalidImageURL
    case invalidBio
    case invalidGender
    case invalidAge
    case invalidLocation
    case invalidEmail
    case invalidPassword
}

class User: NSObject, NSCoding {
    var id: String?
    var firstName: String?
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
    var password: String?
    var token: String?
    var preferences: [String:Any]?
    var data: [String:Any]?
    

//    //MARK: Initialization Dont believe we need to initialize twice with the lowere json 
//    init(id: String, firstName: String, lastName: String, imageURL: String, bio: String, gender: String, age: Int, location: [Float], swipes: [String: Int], mates: [Any], potentialMates: [Any], blockedMates: [Any], seenProfiles: [Any], email: String, password: String, token: String, preferences: [String:Any], data: [String:Any]) {
//        self.id = id
//        self.firstName = firstName
//        self.lastName = lastName
//        self.imageURL = imageURL
//        self.bio = bio
//        self.gender = gender
//        self.age = age
//        self.location = location
//        self.swipes = swipes
//        self.mates = mates
//        self.potentialMates = potentialMates
//        self.seenProfiles = seenProfiles
//        self.blockedMates = blockedMates
//        self.email = email
//        self.password = password
//        self.token = token
//        self.preferences = preferences
//        self.data = data
//    }
    
    //JSON initializer
    // https://developer.apple.com/swift/blog/?id=37
    init?(json: [String: Any]) throws {
        guard let id = json["id"] as! String? else {
            throw UserInitError.invalidId
        }
        guard let firstName = json["firstName"] as! String? else {
            throw UserInitError.invalidFirstName
        }
        guard let lastName = json["lastName"] as! String? else {
            throw UserInitError.invalidLastName
        }
        guard let imageURL = json["imageURL"] as! String? else {
            throw UserInitError.invalidImageURL
        }
        guard let bio = json["bio"] as! String? else {
            throw UserInitError.invalidBio
        }
        guard let gender = json["gender"] as! String? else {
            throw UserInitError.invalidGender
        }
        guard let age = json["age"] as! Int? else {
            throw UserInitError.invalidAge
        }
        guard let location = json["location"] as! [Float]? else {
            throw UserInitError.invalidLocation
        }
        let swipes = json["swipes"] as! [String: Int]?
        let mates = json["mates"] as! [Any]?
        let potentialMates = json["potentialMates"] as! [Any]?
        let seenProfiles = json["seenProfiles"] as! [Any]?
        let blockedMates = json["blockedMates"] as! [Any]?
        guard let email = json["email"] as! String? else {
            throw UserInitError.invalidEmail
        }
        let password = json["password"] as! String?
        let token = json["token"] as! String?
        let preferences = json["preferences"] as! [String:Any]?
        let data = json["data"] as! [String:Any]?

        self.id = id
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
    
    struct PropertyKey {
        static let id = "id"
        static let firstName = "firstName"
        static let lastName = "lastName"
        static let imageURL = "imageURL"
        static let bio = "bio"
        static let gender = "gender"
        static let age = "age"
        static let location = "location"
        static let swipes = "swipes"
        static let mates = "mates"
        static let potentialMates = "potentialMates"
        static let seenProfiles = "seenProfiles"
        static let blockedMates = "blockedMates"
        static let email = "email"
        static let password = "password"
        static let token = "token"
        static let preferences = "preferences"
        static let data = "data"
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: PropertyKey.id)
        aCoder.encode(firstName, forKey: PropertyKey.firstName)
        aCoder.encode(lastName, forKey: PropertyKey.lastName)
        aCoder.encode(imageURL, forKey: PropertyKey.imageURL)
        aCoder.encode(bio, forKey: PropertyKey.bio)
        aCoder.encode(gender, forKey: PropertyKey.gender)
        aCoder.encode(age, forKey: PropertyKey.age)
        aCoder.encode(location, forKey: PropertyKey.location)
        aCoder.encode(swipes, forKey: PropertyKey.swipes)
        aCoder.encode(mates, forKey: PropertyKey.mates)
        aCoder.encode(potentialMates, forKey: PropertyKey.potentialMates)
        aCoder.encode(seenProfiles, forKey: PropertyKey.seenProfiles)
        aCoder.encode(blockedMates, forKey: PropertyKey.blockedMates)
        aCoder.encode(email, forKey: PropertyKey.email)
        aCoder.encode(password, forKey: PropertyKey.password)
        aCoder.encode(token, forKey: PropertyKey.token)
        aCoder.encode(preferences, forKey: PropertyKey.preferences)
        aCoder.encode(data, forKey: PropertyKey.data)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        // The name is required. If we cannot decode a name string, the initializer should fail.
        //guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Meal object.", log: OSLog.default, type: .debug)
            return nil
        
        // Because photo is an optional property of Meal, just use conditional cast.
       // let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        
        //let rating = aDecoder.decodeInteger(forKey: PropertyKey.rating)
        
        // Must call designated initializer.
        //self.init(name: name, photo: photo, rating: rating)
        
    }
}


