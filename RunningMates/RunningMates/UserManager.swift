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
}


class UserManager: NSObject {
    static let instance = UserManager()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    override init() {

    }
    
    func requestForSignup(email: String?, password: String?, completion: @escaping (String)->()) {
        let rootUrl: String = appDelegate.rootUrl
        let url = rootUrl + "api/signup"
        
        let params: Parameters = [
            "email": email!,
            "password": password!
        ]

        let _request = Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default)
                .responseJSON { response in
                    switch response.result {
                        case .success:
                            if let jsonObj = response.result.value as? [String:Any] {

                                let token = (jsonObj["token"] as! String)
                                let user = (jsonObj["user"] as? [String:Any])!
                                
                                UserDefaults.standard.set(email!, forKey: "email")
                                UserDefaults.standard.set(token, forKey: "token")

                                UserDefaults.standard.set(password!, forKey: "password")
                                
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
                                if (user["bio"] != nil) {
                                    UserDefaults.standard.set(user["bio"]!, forKey: "bio")
                                }
                                
                                if (user["imageURL"] != nil) {
                                    UserDefaults.standard.set(user["imageURL"]!, forKey: "imageURL")
                                }
                                
                                if (user["images"] != nil) {
                                    let images = user["images"] as! [String]
                                    UserDefaults.standard.set(images, forKey: "images")
                                }
                                
                                if (user["preferences"] != nil) {
                                    
                                    var preferences = (user["preferences"] as? [String:Any])!
                                    if let proximityPrefs = (preferences["proximity"]  as? Double) {
                                        preferences["proximity"] = proximityPrefs
                                    }
                                    UserDefaults.standard.set(preferences, forKey: "preferences")
                                }
                                
                                if (user["requestsReceived"] != nil) {
                                    
                                    var requestsReceived = (user["requestsReceived"] as? [String:Any])!
                                    UserDefaults.standard.set(requestsReceived, forKey: "requestsReceived")
                                }
                                
                                if (user["data"] != nil) {
                                    
                                    //                                var data = [String:Any]()
                                    //                                let totalMilesRun = user["data"]!["totalMilesRun"] as! Int
                                    //                                let totalElevationClimbed = user["data"]!["totalElevationClimbed"]
                                    //                                let runsPerWeek = user["data"]!["runsPerWeek"]
                                    //                                let milesPerWeek = user["data"]!["milesPerWeek"]
                                    //                                let racesDone = user[
                                    //                                racesDone: [],
                                    //                                averageRunLength: { type: Number, default: 0 },
                                    //                                longestRun: { type: String, default: '' },
                                    //                                preferences["gender"] = genderPref
                                    //                                preferences["runLength"] = runLengthPref!
                                    //                                preferences["age"] = agePref
                                    //                                if (user["preferences"] != nil) {
                                    //                                    if let proximityPrefs = (user["preferences"]!["proximity"]  as? Double) {
                                    //                                        preferences["proximity"] = proximityPrefs
                                    //                                    }
                                    //                                }
                                    //                                let data = NSKeyedArchiver.archivedData(withRootObject: user["data"])
                                    //                                UserDefaults.standard.set(data, forKey: "data")
                                    UserDefaults.standard.set(user["data"], forKey: "data")
                                }
                                if (user["desiredGoals"] != nil) {
                                    UserDefaults.standard.set(user["desiredGoals"]!, forKey: "desiredGoals")
                                }
                                if (user["_id"] != nil) {
                                    UserDefaults.standard.set(user["_id"]!, forKey: "id")
                                }
                                
                                completion("success")
                            }
                        case .failure(let error):
                            print(error)
                            completion("error")
                    }
            }
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
                        var user = (jsonUser["user"] as? [String:AnyObject])!

                        // Check token and prevToken storage and comparison if any errors occur
                        let token = (jsonUser["token"] as? String)
                        
                        let prevToken = String(describing: UserDefaults.standard.value(forKey: "token"))
                       
                        // Check to see if this user is already saved in the UserDefaults, if so, we don't need to save all of their information again.
                        if (token != prevToken) {
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
                            if (user["bio"] != nil) {
                                UserDefaults.standard.set(user["bio"]!, forKey: "bio")
                            }
                            
                            if (user["imageURL"] != nil) {
                                UserDefaults.standard.set(user["imageURL"]!, forKey: "imageURL")
                            }
                            
                            if (user["images"] != nil) {
                                let images = user["images"] as! [String]
                                UserDefaults.standard.set(images, forKey: "images")
                            }
                            
                            if (user["requestsReceived"] != nil) {
                                var requestsReceived = (user["requestsReceived"] as? [String:Any])!
                                UserDefaults.standard.set(requestsReceived, forKey: "requestsReceived")
                            }
                            
                            if (user["preferences"] != nil) {
        
                                var preferences = [String:Any]()
                                let genderPref = user["preferences"]!["gender"] as! [String]
                                let runLengthPref = user["preferences"]!["runLength"]
                                let agePref = user["preferences"]!["age"]
                                preferences["gender"] = genderPref
                                preferences["runLength"] = runLengthPref!
                                preferences["age"] = agePref
                                if (user["preferences"] != nil) {
                                    if let proximityPrefs = (user["preferences"]!["proximity"]  as? Double) {
                                        preferences["proximity"] = proximityPrefs
                                    }
                                }
                                UserDefaults.standard.set(preferences, forKey: "preferences")
                            }
                            
                            if (user["data"] != nil) {

//                                var data = [String:Any]()
//                                let totalMilesRun = user["data"]!["totalMilesRun"] as! Int
//                                let totalElevationClimbed = user["data"]!["totalElevationClimbed"]
//                                let runsPerWeek = user["data"]!["runsPerWeek"]
//                                let milesPerWeek = user["data"]!["milesPerWeek"]
//                                let racesDone = user[
//                                racesDone: [],
//                                averageRunLength: { type: Number, default: 0 },
//                                longestRun: { type: String, default: '' },
//                                preferences["gender"] = genderPref
//                                preferences["runLength"] = runLengthPref!
//                                preferences["age"] = agePref
//                                if (user["preferences"] != nil) {
//                                    if let proximityPrefs = (user["preferences"]!["proximity"]  as? Double) {
//                                        preferences["proximity"] = proximityPrefs
//                                    }
//                                }
//                                let data = NSKeyedArchiver.archivedData(withRootObject: user["data"])
//                                UserDefaults.standard.set(data, forKey: "data")
                                UserDefaults.standard.set(user["data"], forKey: "data")
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

        
        // https://stackoverflow.com/questions/47775600/alamofire-post-request-with-headers
//        let urlString = rootUrl + "api/user/" + userEmail
//        let url = URL(string: urlString)
//        var urlRequest = URLRequest(url: url!)
//
//        urlRequest.httpMethod = HTTPMethod.get.rawValue
//        urlRequest.addValue("jwt " + userToken, forHTTPHeaderField: "Authorization")
//        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
    

        let params : [String:Any] = [
            "email": userEmail,
        ]
        let _request = Alamofire.request(url, parameters: params)
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
    
    
    func requestPotentialMatches(userEmail: String, location: [Double], maxDistance: Double, completion: @escaping ([sortedUser])->()){
        let rootUrl: String = appDelegate.rootUrl
        
        var usersList = [sortedUser]()

        let userToken: String = UserDefaults.standard.string(forKey: "token")!
        
        let headers : [String:String] = [
            "Authorization": userToken,
            "Content-Type": "application/json"
        ]
        let params: [String: Any] = [
            "location": location,
            "email": userEmail,
            "maxDistance": maxDistance
            ]
        let url = rootUrl + "api/users"
        
        let request = Alamofire.request(url, method: .get, parameters: params, headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success:
                    
                    if let jsonResult = response.result.value as? [[String:Any]] {
                        for jsonUser in jsonResult {
                            do {
                                let user = try User(json: (jsonUser["user"] as? [String:Any])!)
                                let matchReason = (jsonUser["matchReason"] as! String)

                                let sortUserInstance = sortedUser(user: user!, matchReason: matchReason);
                                
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
                completion(usersList)
        }
    }
    
    
    func sendMatchRequest(userId: String, targetId: String, firstName: String, completion: @escaping (String, String)->()) {
        
        let rootUrl: String = appDelegate.rootUrl
        
        let userToken: String = UserDefaults.standard.string(forKey: "token")!
        
        let headers : [String:String] = [
            "Authorization": userToken,
            "Content-Type": "application/json"
        ]
        
        
        // alamofire request
        let params: [String: Any] = [
            "userId": userId,
            "targetId": targetId
        ]
        
        let url = rootUrl + "api/match"
        
        var title = ""
        var message = ""
        
        let _request = Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
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
        let userToken: String = UserDefaults.standard.string(forKey: "token")!
        
        let headers : [String:String] = [
            "Authorization": userToken,
            "Content-Type": "application/json"
        ]
        
        let url = rootUrl + "api/users/" + userEmail
        
        var title = ""
        var message = ""
        
        let _request = Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success:
                        title = "You Have Updated Your Profile"
                        message = "Find Some New RunningMates!"
                        completion(title, message)
                case .failure(let error):
                    print("*error posting profile updates*")
                    print(error)
                }
        }
        debugPrint("whole _request ****",_request)
    }
    
    
    
    func requestForSignOut(completion: @escaping ()->()) {
        let rootUrl: String = appDelegate.rootUrl
        let userToken: String = UserDefaults.standard.string(forKey: "token")!
        
        let headers : [String:String] = [
            "Authorization": userToken,
            "Content-Type": "application/json"
        ]
        
        let url = rootUrl + "api/signout"

        let _request = Alamofire.request(url, method: .post, headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success: // clear user defaults, route to sign in page
                    let userID : String = UserDefaults.standard.value(forKey: "id") as! String
                    SocketIOManager.instance.logout(userID: userID)
                    self.removeUserDefaults()
                    completion()
                case .failure:
                    print("error signing out")
                }
        }
//        debugPrint("whole _request ****",_request)
    }
    func sendSafeTrackMessage(toPhoneNumber: String?, completion: @escaping (String)->()) {
        let rootUrl: String = appDelegate.rootUrl
        let url = rootUrl + "api/safetrack"
        
        let params: Parameters = [
            "toPhoneNumber": toPhoneNumber!,
        ]
        
        let _request = Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default)
            .responseJSON { response in
                switch response.result {
                case .success:
                    if let jsonObj = response.result.value as? [String:Any] {
                        
//                        let token = (jsonObj["token"] as! String)
//                        let user = (jsonObj["user"] as? [String:Any])!
//
//                        UserDefaults.standard.set(email!, forKey: "email")
//                        UserDefaults.standard.set(token, forKey: "token")
//
//                        UserDefaults.standard.set(password!, forKey: "password")
                        
                        completion("success")
                    }
                case .failure(let error):
                    print(error)
                    completion("error")
                }
        }
        
    }
    // https://stackoverflow.com/questions/43402032/how-to-remove-all-userdefaults-data-swift
    func removeUserDefaults() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
    }
}

