//
//  File.swift
//  RunningMates
//
//  Created by Sara Topic on 26/04/2018.
//  Copyright © 2018 Apple Inc. All rights reserved.
//
import os.log
import UIKit

    //source: https://developer.apple.com/library/content/referencelibrary/GettingStarted/DevelopiOSAppsSwift/PersistData.html
    class EmergencyContact: NSObject, NSCoding {
        
        //MARK: Properties
    
        var FirstName: String
        var LastName: String
        var phoneNumber: String
        
        //MARK: Archiving Paths
        static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
        static let ArchiveURL = DocumentsDirectory.appendingPathComponent("contacts")
        
        //MARK: Types
        
        struct PropertyKey {
            static let FirstName = "FirstName"
            static let LastName = "LastName"
            static let phoneNumber = "phoneNumber"
        }
        
        //MARK: Initialization
        
        init?(FirstName: String, LastName: String, phoneNumber: String) {
            
            // The name must not be empty
            guard !FirstName.isEmpty else {
                return nil
            }
            
//            // The rating must be between 0 and 5 inclusively
//            guard (rating >= 0) && (rating <= 5) else {
//                return nil
//            }
            
            // Initialization should fail if there is no name or if the rating is negative.
            if FirstName.isEmpty {
                return nil
            }
            
            // Initialize stored properties.
            self.FirstName = FirstName
            self.LastName = LastName
            self.phoneNumber = phoneNumber
            
        }
        
        //MARK: NSCoding
        
        func encode(with aCoder: NSCoder) {
            aCoder.encode(FirstName, forKey: PropertyKey.FirstName)
            aCoder.encode(LastName, forKey: PropertyKey.LastName)
            aCoder.encode(phoneNumber, forKey: PropertyKey.phoneNumber)
        }
        
        required convenience init?(coder aDecoder: NSCoder) {
            
            // The name is required. If we cannot decode a name string, the initializer should fail.
            guard let FirstName = aDecoder.decodeObject(forKey: PropertyKey.FirstName) as? String else {
                os_log("Unable to decode the first name for a Emergency object.", log: OSLog.default, type: .debug)
                return nil
            }
            guard let phoneNumber = aDecoder.decodeObject(forKey: PropertyKey.phoneNumber) as? String else {
                os_log("Unable to decode the phone number for a Emergency object.", log: OSLog.default, type: .debug)
                return nil
            }
            
         
            
            // Because photo is an optional property of Meal, just use conditional cast.
            let LastName = aDecoder.decodeObject(forKey: PropertyKey.LastName) as? String
            
         //   let rating = aDecoder.decodeInteger(forKey: PropertyKey.rating)
            
            // Must call designated initializer.
            self.init(FirstName: FirstName, LastName: LastName!, phoneNumber: phoneNumber)
            
        }
}
