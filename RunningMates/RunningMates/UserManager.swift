//
//  UserManager.swift
//  RunningMates
//
//  Created by Sudikoff Lab iMac on 5/4/18.
//  Copyright © 2018 Apple Inc. All rights reserved.
//

import Foundation
import Alamofire


struct sortedUser {
    var user: User
    var matchReason: String
    var score: Float
}


class UserManager: NSObject {
    static let instance = UserManager()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    override init() {

    }
    
    func requestForLogin(Url:String, password: String?, email: String?, completion: @escaping (String)->()) {
        
        let params: Parameters = [
            "email": email!,
            "password": password!
        ]
        
        let _request = Alamofire.request(Url, method: .post, parameters: params, encoding: JSONEncoding.default)
            .responseJSON { response in
                switch response.result {
                case .success:
                    if let jsonUser = response.result.value as? [String:Any] {
                        var user = (jsonUser["user"] as? [String:Any])!
                        
                        // Check token and prevToken storage and comparison if any errors occur
                        let token = (jsonUser["token"] as? String)
                        
                        let prevToken = String(describing: UserDefaults.standard.value(forKey: "token"))
                        // Check to see if this user is already saved in the UserDefaults, if so, we don't need to save all of their information again.
                        if !(token == prevToken) {
                            UserDefaults.standard.set(token, forKey: "token")
                            if (user["firstName"] != nil) {
                                let firstName = user["firstName"] as! String
                                UserDefaults.standard.set(firstName, forKey: "firstName")
                                
                            }
                            if (user["email"] != nil) {
                                UserDefaults.standard.set(user["email"]!, forKey: "email")
                            }
                            if (user["_id"] != nil) {
                                UserDefaults.standard.set(user["_id"]!, forKey: "id")
                            }
                            if (user["lastName"] != nil) {
                                UserDefaults.standard.set(user["lastName"]!, forKey: "lastName")
                            }
                            
                            if (user["imageURL"] != nil) {
                                UserDefaults.standard.set(user["imageURL"]!, forKey: "imageURL")
                            }
                            
                            if (user["images"] != nil) {
                                UserDefaults.standard.set(user["images"]!, forKey: "images")
                            }
                            
                            if (user["preferences"] != nil) {
                                print("\n\nHERE FOR PREFERENCES OF LOGIN \n\n ")
                                print(user["preferences"]!)
                                UserDefaults.standard.set(user["preferences"]!, forKey: "preferences")
                            }
                            
                            if (user["data"] != nil) {
                                UserDefaults.standard.set(user["data"]!, forKey: "data")
                            }
                            if (user["desiredGoals"] != nil) {
                                UserDefaults.standard.set(user["desiredGoals"]!, forKey: "desiredGoals")
                            }
                            
                        }
                        completion(user["_id"] as! String)
                    }
                case .failure(let error):
                    print(error)
                    completion("error")
                }
        }
    }
    
    
    func requestUserObject(userEmail: String, completion: @escaping (User)->()) {
        let rootUrl: String = appDelegate.rootUrl
        let url = rootUrl + "api/user/" + userEmail
        
        print("user email" + userEmail)
        
        let params : [String:Any] = [
            "email": userEmail
        ]
        let _request = Alamofire.request(url, method: .get, parameters: params)
            .responseJSON { response in
                switch response.result {
                case .success:
                    if let jsonUser = response.result.value as? [String:Any] {
                        do {
                            let user = try User(json: (jsonUser as [String:Any]))
                            if (user != nil) {
                                completion(user!)
                            } else {
                                print("nil")
                            }
                        } catch UserInitError.invalidId {
                            print("invalid id")
                        } catch UserInitError.invalidFirstName {
                            print("invalid first name")
                        } catch UserInitError.invalidLastName {
                            print("invalid last name")
                        } catch UserInitError.invalidImageURL {
                            print("invalid image url")
                        } catch UserInitError.invalidBio {
                            print("invalid bio")
                        } catch UserInitError.invalidGender {
                            print("invalid gender")
                        } catch UserInitError.invalidAge {
                            print("invalid age")
                        } catch UserInitError.invalidLocation {
                            print("invalid location")
                        } catch UserInitError.invalidEmail {
                            print("invalid email")
                        } catch UserInitError.invalidPassword {
                            print("invalid password")
                        } catch {
                            print("other error")
                        }
                    } else {
                        print("error creating user for user id")
                    }
                    
                case .failure(let error):
                    print("failure: error creating user for user id")
                    print(error)
                }
        }
    }
    
    
    func requestPotentialMatches(userEmail: String, location: [Float], completion: @escaping ([sortedUser])->()){
        let rootUrl: String = appDelegate.rootUrl
        
        var usersList = [sortedUser]()
        
        let params : [String: Any] = [
            "email": userEmail,
            "location": location
        ]
        
        let url = rootUrl + "api/users"
        
        var headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        let request = Alamofire.request(url, method: .get, parameters: params)
            .responseJSON { response in
                switch response.result {
                case .success:
                    
                    if let jsonResult = response.result.value as? [[String:Any]] {
                        for jsonUser in jsonResult {
                            do {
                                let user = try User(json: (jsonUser["user"] as? [String:Any])!)
                                let matchReason = (jsonUser["matchReason"] as! String)
                                print(user!)
                                print(jsonUser)
                                let score = (jsonUser["score"] as! Float)
                                
                                let sortUserInstance = sortedUser(user: user!, matchReason: matchReason, score: score)
                                
                                if (user != nil) {
                                    usersList.append(sortUserInstance)
                                } else {
                                    print("nil")
                                }
                            } catch UserInitError.invalidId {
                                print("invalid id")
                            } catch UserInitError.invalidFirstName {
                                print("invalid first name")
                            } catch UserInitError.invalidLastName {
                                print("invalid last name")
                            } catch UserInitError.invalidImageURL {
                                print("invalid image url")
                            } catch UserInitError.invalidBio {
                                print("invalid bio")
                            } catch UserInitError.invalidGender {
                                print("invalid gender")
                            } catch UserInitError.invalidAge {
                                print("invalid age")
                            } catch UserInitError.invalidLocation {
                                print("invalid location")
                            } catch UserInitError.invalidEmail {
                                print("invalid email")
                            } catch UserInitError.invalidPassword {
                                print("invalid password")
                            } catch {
                                print("other error")
                            }
                        }
                        completion(usersList)
                    } else {
                        print("error creating user")
                    }
                    
                case .failure(let error):
                    print("error fetching users")
                    print(error)
                }
        }
    }
    
    
    func sendMatchRequest(userId: String, targetId: String, firstName: String, completion: @escaping (String, String)->()) {
        
        let rootUrl: String = appDelegate.rootUrl
        
        // alamofire request
        let params: [String: Any] = [
            "userId": userId,
            "targetId": targetId
        ]
        
        let url = rootUrl + "api/match"
        
        var title = ""
        var message = ""
        
        let _request = Alamofire.request(url, method: .post, parameters: params)
            .responseJSON { response in
                switch response.result {
                case .success:
                    let responseDictionary = response.result.value as! [String:Any]
                    if (String(describing: responseDictionary["response"]!) == "match") {
                        title = "You matched with \(firstName)"
                        message = "Go to your chat to say hello!"
                    } else {
                        title = "Your request to \(firstName) has been sent!"
                        message = "Keep running!"
                    }
                case .failure(let error):
                    print("error fetching users")
                    print(error)
                }
                completion(title, message)
        }
    }
    
    
    
    func requestUserUpdate(userEmail: String, params: [String:Any], completion: @escaping (String, String)-> ()){
        
        let rootUrl: String = appDelegate.rootUrl
        
//        let params : [String: Any]
        
//        params = [
//            "email": self.userEmail,
//            "firstName": nameTextView.text!,
//            "bio": bioTextView.text!,
//            "images": self.profileImageUrls,
//            "milesPerWeek": milesPerWeekTextField.text!,
//            "totalElevation": totalElevationTextField.text!,
//            "totalMiles": totalMilesTextField.text!,
//            "longestRun": longestRunTextView.text!,
//            "racesDone": racesDoneTextView.text!,
//            "runsPerWeek": runsPerWeekTextField.text!,
//            "kom": KOMsTextField.text!,
//            "frequentSegments": frequentSegmentsTextView.text!
//        ]
        
        let url = rootUrl + "api/user/" + userEmail
        
        var title = ""
        var message = ""
        
        let _request = Alamofire.request(url, method: .post, parameters: params)
            .responseJSON { response in
                switch response.result {
                case .success:
                    let responseDictionary = response.result.value as! [String:Any]
                    if (responseDictionary != nil && responseDictionary["response"] != nil) {
                        if (String(describing: responseDictionary["response"]!) == "updated user") {
                            title = "You Have Updated Your Profile"
                            message = "Find Some New RunningMates!"
                        }
                        completion(title, message)
                        print("*** success in update*** ")
                    }
                case .failure(let error):
                    print("*error posting profile updates*")
                    print(error)
                }
        }
        debugPrint("whole _request ****",_request)
    }
    
    
    
    func logout(userID: String) {
        
    }
}

