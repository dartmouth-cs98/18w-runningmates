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
    var firstName: String
    var lastName: String?
    var imageURL: String?
    var images: [String:Any]?
    var bio: String
    var gender: String?
    var age: Int?
    var location: [Float]
    var desiredGoals: [Any]?
    var swipes: [String: Int]?
    var mates: [Any]?
    var potentialMates: [Any]?
    var blockedMates: [Any]?
    var seenProfiles: [Any]?
    var email: String
    var password: String?
    var token: String?
    var preferences: [String:Any]?
    var thirdPartyIds: [String:Any]?
    var data: [String:Any]?
    
    
    //JSON initializer
    // https://developer.apple.com/swift/blog/?id=37
    init?(json: [String: Any]) throws {
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
        let images = json["images"] as! [String: Any]?
        let swipes = json["swipes"] as! [String: Int]?
        let mates = json["mates"] as! [Any]?
        let desiredGoals = json["desiredGoals"] as! [Any]?
        let potentialMates = json["potentialMates"] as! [Any]?
        let seenProfiles = json["seenProfiles"] as! [Any]?
        let blockedMates = json["blockedMates"] as! [Any]?
        let thirdPartyIds = json["thirdPartyIds"] as! [String: Any]?
        guard let email = json["email"] as! String? else {
            throw UserInitError.invalidEmail
        }
        let password = json["password"] as! String?
        let token = json["token"] as! String?
        let preferences = json["preferences"] as! [String:Any]?
        let data = json["data"] as! [String:Any]?

        self.firstName = firstName
        self.lastName = lastName
        self.imageURL = imageURL
        self.images = images
        self.bio = bio
        self.gender = gender
        self.age = age
        self.location = location
        self.desiredGoals = desiredGoals
        self.swipes = swipes
        self.mates = mates
        self.potentialMates = potentialMates
        self.seenProfiles = seenProfiles
        self.blockedMates = blockedMates
        self.email = email
        self.password = password
        self.token = token
        self.preferences = preferences
        self.thirdPartyIds = thirdPartyIds
        self.data = data
    }
    
    struct PropertyKey {
        static let firstName = "firstName"
        static let lastName = "lastName"
        static let imageURL = "imageURL"
        static let images = "images"
        static let bio = "bio"
        static let gender = "gender"
        static let age = "age"
        static let location = "location"
        static let desiredGoals = "desiredGoals"
        static let swipes = "swipes"
        static let mates = "mates"
        static let potentialMates = "potentialMates"
        static let seenProfiles = "seenProfiles"
        static let blockedMates = "blockedMates"
        static let email = "email"
        static let password = "password"
        static let token = "token"
        static let preferences = "preferences"
        static let thirdPartyIds = "thirdPartyIds"
        static let data = "data"
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(firstName, forKey: PropertyKey.firstName)
        aCoder.encode(lastName, forKey: PropertyKey.lastName)
        aCoder.encode(imageURL, forKey: PropertyKey.imageURL)
        aCoder.encode(images, forKey: PropertyKey.images)
        aCoder.encode(bio, forKey: PropertyKey.bio)
        aCoder.encode(gender, forKey: PropertyKey.gender)
        aCoder.encode(age, forKey: PropertyKey.age)
        aCoder.encode(location, forKey: PropertyKey.location)
        aCoder.encode(swipes, forKey: PropertyKey.swipes)
        aCoder.encode(desiredGoals, forKey: PropertyKey.desiredGoals)
        aCoder.encode(mates, forKey: PropertyKey.mates)
        aCoder.encode(potentialMates, forKey: PropertyKey.potentialMates)
        aCoder.encode(seenProfiles, forKey: PropertyKey.seenProfiles)
        aCoder.encode(blockedMates, forKey: PropertyKey.blockedMates)
        aCoder.encode(email, forKey: PropertyKey.email)
        aCoder.encode(password, forKey: PropertyKey.password)
        aCoder.encode(token, forKey: PropertyKey.token)
        aCoder.encode(preferences, forKey: PropertyKey.preferences)
        aCoder.encode(thirdPartyIds, forKey: PropertyKey.thirdPartyIds)
        aCoder.encode(data, forKey: PropertyKey.data)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        // The first name is required. If we cannot decode a name string, the initializer should fail.
        guard let firstName = aDecoder.decodeObject(forKey: PropertyKey.firstName) as? String else {
            os_log("Unable to decode the name for a user.", log: OSLog.default, type: .debug)
            return nil
        }
        let lastName = aDecoder.decodeObject(forKey: PropertyKey.lastName) as? String
        let imageURL = aDecoder.decodeObject(forKey: PropertyKey.imageURL) as? String
        let images = aDecoder.decodeObject(forKey: PropertyKey.images) as? [String: Any]
        let bio = aDecoder.decodeObject(forKey: PropertyKey.bio) as? String
        let gender = aDecoder.decodeObject(forKey: PropertyKey.gender) as? String
        let age = aDecoder.decodeObject(forKey: PropertyKey.age) as? Int
        let location = aDecoder.decodeObject(forKey: PropertyKey.location) as? [Float]
        let desiredGoals = aDecoder.decodeObject(forKey: PropertyKey.desiredGoals) as? [Any]
        let swipes = aDecoder.decodeObject(forKey: PropertyKey.swipes) as? [String: Int]
        let mates = aDecoder.decodeObject(forKey: PropertyKey.mates) as? [Any]
        let potentialMates = aDecoder.decodeObject(forKey: PropertyKey.potentialMates) as? [Any]
        let seenProfiles = aDecoder.decodeObject(forKey: PropertyKey.seenProfiles) as? [Any]
        let blockedMates = aDecoder.decodeObject(forKey: PropertyKey.blockedMates) as? [Any]
        let email = aDecoder.decodeObject(forKey: PropertyKey.email) as? String
        let password = aDecoder.decodeObject(forKey: PropertyKey.password) as? String
        let token = aDecoder.decodeObject(forKey: PropertyKey.token) as? String
        let preferences = aDecoder.decodeObject(forKey: PropertyKey.preferences) as? [String: Any]
        let thirdPartyIds = aDecoder.decodeObject(forKey: PropertyKey.thirdPartyIds) as? [String: Any]
        let data = aDecoder.decodeObject(forKey: PropertyKey.data) as? [String: Any]
        
        let json: [String: Any] = [PropertyKey.firstName: firstName,
                                   PropertyKey.lastName: lastName!,
                                   PropertyKey.imageURL: imageURL!,
                                   PropertyKey.images: images!,
                                   PropertyKey.bio: bio!,
                                   PropertyKey.gender: gender!,
                                   PropertyKey.age: age!,
                                   PropertyKey.location: location!,
                                   PropertyKey.desiredGoals: desiredGoals!,
                                   PropertyKey.swipes: swipes!,
                                   PropertyKey.mates: mates!,
                                   PropertyKey.potentialMates: potentialMates!,
                                   PropertyKey.seenProfiles: seenProfiles!,
                                   PropertyKey.blockedMates: blockedMates!,
                                   PropertyKey.email: email!,
                                   PropertyKey.password: password!,
                                   PropertyKey.token: token!,
                                   PropertyKey.preferences: preferences!,
                                   PropertyKey.thirdPartyIds: thirdPartyIds!,
                                   PropertyKey.data: data!]
        
        try? self.init(json: json)
    }
}


