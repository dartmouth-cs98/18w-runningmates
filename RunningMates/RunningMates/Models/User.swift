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
    var location: String
    var email: String
    var username: String
    var password: String
    var token: String

    //MARK: Initialization
    init(firstName: String, lastName: String, imageURL: String, bio: String, gender: String, age: Int, location: String, email: String, username: String, password: String, token: String) {
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
}
