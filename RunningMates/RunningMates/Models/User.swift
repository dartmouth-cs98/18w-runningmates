//
//  UserModel.swift
//  OAuthSwift
//
//  Created by Sudikoff Lab iMac on 2/15/18.
//  Copyright © 2018 Dongri Jin. All rights reserved.
//
// Used the following tutorial for reference: https://developer.apple.com/library/content/referencelibrary/GettingStarted/DevelopiOSAppsSwift/PersistData.html#//apple_ref/doc/uid/TP40015214-CH14-SW1

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
    case invalidMates
    case invalidPotentialMates
    case invalidSeenProfiles
    case invalidBlockedMates
    case invalidRequestsReceived
}

class User: NSObject, NSCoding {
    var id: String?
    var firstName: String?
    var lastName: String?
    var imageURL: String
    var images: [String]
    var bio: String
    var gender: String
    var age: Int
    var location: [Float]
    var swipes: [String: Int]?
    var mates: [String: Any]?
    var potentialMates: [String: Any]?
    var blockedMates: [String: Any]?
    var requestsReceived: [String: Any]?

    var seenProfiles: [Any]?
    var email: String
    var password: String?
    var token: String?
    var preferences: [String:Any]?
    var thirdPartyIds: [String:Any]?
    var data: [String:Any]?
    
    
    //    //MARK: Initialization Dont believe we need to initialize twice with the lowere json
    init(id: String, firstName: String, lastName: String, imageURL: String, images: [String], bio: String, gender: String, age: Int, location: [Float], swipes: [String: Int], mates: [String: Any], potentialMates: [String: Any], blockedMates: [String: Any], requestsReceived: [String: Any], seenProfiles: [Any], email: String, password: String, token: String, preferences: [String:Any], thirdPartyIds: [String:Any], data: [String:Any]) {

        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.imageURL = imageURL
        self.images = images
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
        self.thirdPartyIds = thirdPartyIds
        self.data = data
    }
    
    //JSON initializer
    // https://developer.apple.com/swift/blog/?id=37
    init?(json: [String: Any]) throws {
//        print("-------JSON IS:-------")
//        print(json)
        guard let id = json["id"] as! String? else {
            throw UserInitError.invalidId
        }
        guard let firstName = json["firstName"] as! String? else {
            throw UserInitError.invalidFirstName
        }
        let lastName = json["lastName"] as! String?
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
        let images = json["images"] as! [String]?

        let mates = json["mates"] as! [String: Any]?
        let potentialMates = json["potentialMates"] as! [String: Any]?
        let seenProfiles = json["seenProfiles"] as! [Any]?
        let blockedMates = json["blockedMates"] as! [String: Any]?
        let requestsReceived = json["requestsReceived"] as! [String: Any]?
        guard let email = json["email"] as! String? else {
            throw UserInitError.invalidEmail
        }
        let password = json["password"] as! String?
        let token = json["token"] as! String?
        let preferences = json["preferences"] as! [String:Any]?
        let data = json["data"] as! [String:Any]?
        let thirdParty = json["thirdPartyIds"] as! [String:Any]?
        
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.imageURL = imageURL
        self.images = images!
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
        self.thirdPartyIds = thirdParty
        self.data = data
    }
    
    struct PropertyKey {
        static let id = "id"
        static let firstName = "firstName"
        static let lastName = "lastName"
        static let imageURL = "imageURL"
        static let images = "images"
        static let bio = "bio"
        static let gender = "gender"
        static let age = "age"
        static let location = "location"
        static let swipes = "swipes"
        static let mates = "mates"
        static let potentialMates = "potentialMates"
        static let seenProfiles = "seenProfiles"
        static let blockedMates = "blockedMates"
        static let requestsReceived = "requestsReceived"
        static let email = "email"
        static let password = "password"
        static let token = "token"
        static let preferences = "preferences"
        static let thirdPartyIds = "thirdPartyIds"
        static let data = "data"
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: PropertyKey.id)
        aCoder.encode(firstName, forKey: PropertyKey.firstName)
        aCoder.encode(lastName, forKey: PropertyKey.lastName)
        aCoder.encode(imageURL, forKey: PropertyKey.imageURL)
        aCoder.encode(images, forKey: PropertyKey.images)
        aCoder.encode(bio, forKey: PropertyKey.bio)
        aCoder.encode(gender, forKey: PropertyKey.gender)
        aCoder.encode(age, forKey: PropertyKey.age)
        aCoder.encode(location, forKey: PropertyKey.location)
        aCoder.encode(swipes, forKey: PropertyKey.swipes)
        aCoder.encode(mates, forKey: PropertyKey.mates)
        aCoder.encode(potentialMates, forKey: PropertyKey.potentialMates)
        aCoder.encode(seenProfiles, forKey: PropertyKey.seenProfiles)
        aCoder.encode(blockedMates, forKey: PropertyKey.blockedMates)
        aCoder.encode(requestsReceived, forKey: PropertyKey.requestsReceived)
        aCoder.encode(email, forKey: PropertyKey.email)
        aCoder.encode(password, forKey: PropertyKey.password)
        aCoder.encode(token, forKey: PropertyKey.token)
        aCoder.encode(preferences, forKey: PropertyKey.preferences)
        aCoder.encode(data, forKey: PropertyKey.data)
    }
    
    // adapted from the following tutorial: https://developer.apple.com/library/content/referencelibrary/GettingStarted/DevelopiOSAppsSwift/PersistData.html#//apple_ref/doc/uid/TP40015214-CH14-SW1
    required convenience init?(coder aDecoder: NSCoder) {
        
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let id = aDecoder.decodeObject(forKey: PropertyKey.id) as? String else {
            os_log("Unable to decode the id for a User object.", log: OSLog.default, type: .debug)
            return nil
        }
        let firstName = aDecoder.decodeObject(forKey: PropertyKey.firstName) as? String
        let lastName = aDecoder.decodeObject(forKey: PropertyKey.lastName) as? String
        let imageURL = aDecoder.decodeObject(forKey: PropertyKey.imageURL) as? String
        let images = aDecoder.decodeObject(forKey: PropertyKey.images) as? [String]

        let bio = aDecoder.decodeObject(forKey: PropertyKey.bio) as? String
        let gender = aDecoder.decodeObject(forKey: PropertyKey.gender) as? String
        let age = aDecoder.decodeInteger(forKey: PropertyKey.age)
        let location = aDecoder.decodeObject(forKey: PropertyKey.location) as? [Float]
        let swipes = aDecoder.decodeObject(forKey: PropertyKey.swipes) as? [String: Int]
        let mates = aDecoder.decodeObject(forKey: PropertyKey.mates) as? [String: Any]
        let potentialMates = aDecoder.decodeObject(forKey: PropertyKey.potentialMates) as? [String: Any]
        let seenProfiles = aDecoder.decodeObject(forKey: PropertyKey.seenProfiles) as? [Any]
        let blockedMates = aDecoder.decodeObject(forKey: PropertyKey.blockedMates) as? [String: Any]
        let requestsReceived = aDecoder.decodeObject(forKey: PropertyKey.potentialMates) as? [String: Any]
        let email = aDecoder.decodeObject(forKey: PropertyKey.email) as? String
        let password = aDecoder.decodeObject(forKey: PropertyKey.password) as? String
        let token = aDecoder.decodeObject(forKey: PropertyKey.token) as? String
        let preferences = aDecoder.decodeObject(forKey: PropertyKey.preferences) as? [String: Any]
        let thirdPartyIds = aDecoder.decodeObject(forKey: PropertyKey.thirdPartyIds) as? [String: Any]
        let data = aDecoder.decodeObject(forKey: PropertyKey.data) as? [String: Any]
        
        // Must call designated initializer.
        //        self.init(name: name, photo: photo, rating: rating)
        self.init(id: id, firstName: firstName!, lastName: lastName!, imageURL: imageURL!, images: images!, bio: bio!, gender: gender!, age: age, location: location!, swipes: swipes!, mates: mates!, potentialMates: potentialMates!, blockedMates: blockedMates!, requestsReceived: requestsReceived!, seenProfiles: seenProfiles!, email: email!, password: password!, token: token!, preferences: preferences!, thirdPartyIds: thirdPartyIds!, data: data!);
    }
}
