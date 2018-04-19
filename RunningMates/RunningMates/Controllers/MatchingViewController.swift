//
//  ViewController.swift
//  FoodTracker
//
//  Created by Divya Kalidindi on 2/15/18.
//  Copyright © 2018 Divya Kalidindi. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation


class MatchingViewController: UIViewController, UIGestureRecognizerDelegate, CLLocationManagerDelegate {

   // MARK: Properties

    var locationManager: CLLocationManager!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    var current_index = 0
//    var rootURl: String = "http://localhost:9090/"
//    var rootURl: String = "https://running-mates.herokuapp.com/"
    var userId: String = ""
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var userEmail: String = ""

    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var milesLabel: UILabel!
    @IBOutlet weak var avgPaceLabel: UILabel!
    
//    //STATIC USERS (NOT FETCHED FROM DATABASE)
//    let myUser1 = User.init(firstName: "Drew", lastName: "Waterman", imageURL: "https://scontent.fzty2-1.fna.fbcdn.net/v/t1.0-9/14055102_1430974263583433_7521632927490477345_n.jpg?oh=48c6995c29eee20d6749c31f961dd708&oe=5B03FC93", bio: "I love running really fast. Try and keep up!", gender: "female", age: 21, location: ["0","0"], email: "email@email.com", username: "drew_username", password: "password", token: "token")

//    let myUser2 = User.init(firstName: "Divya", lastName: "Kalidindi", imageURL: "https://scontent.fzty2-1.fna.fbcdn.net/v/t1.0-9/11011108_721832241247638_7480659355385060361_n.jpg?oh=32815d13cbfedff312b0aa696a0856d6&oe=5B0A6634", bio: "Running is so fun!", gender: "female", age: 21, location: "San Jose, California", email: "email@email.com", username: "divya_username", password: "password", token: "token")
//
//    let myUser3 = User.init(firstName: "Brian", lastName: "Francis", imageURL: "https://scontent.fzty2-1.fna.fbcdn.net/v/t1.0-9/10343026_10208475643911796_8181307666930996163_n.jpg?oh=05206a7f2b629969f6a59cded20bb032&oe=5B1465C9", bio: "running is mah lyfe", gender: "male", age: 21, location: "Menlo, California", email: "email@email.com", username: "brian_username", password: "password", token: "token")
//
//    let myUser4 = User.init(firstName: "Shea", lastName: "Wojciehowski", imageURL: "https://scontent.fzty2-1.fna.fbcdn.net/v/t1.0-9/12920343_920606948037536_7665732452654505496_n.jpg?oh=97c2240c683b256906b9a1a554dc37e8&oe=5B188030", bio: "RUNNING RUNNING RUNNING", gender: "female", age: 21, location: "Seattle, Washington", email: "email@email.com", username: "shea_username", password: "password", token: "token")
//
//    let myUser5 = User.init(firstName: "Sara", lastName: "Topic", imageURL: "https://scontent.fzty2-1.fna.fbcdn.net/v/t1.0-9/18300829_10203269778100892_1763409033707054557_n.jpg?oh=778da3fbcfcb259557173978d219dd74&oe=5B1F3980", bio: "Need 1 for run", gender: "female", age: 21, location: "Manchester, New Hamsphire", email: "email@email.com", username: "sara_username", password: "password", token: "token")
//
//    let myUser6 = User.init(firstName: "Jon", lastName: "Gonzalez", imageURL: "https://scontent.fzty2-1.fna.fbcdn.net/v/t1.0-1/10155896_10201446542802611_5710423303942551522_n.jpg?oh=9b1c5d9f02ddb0ff330bf26a9c5fca97&oe=5B19F862", bio: "Come run with me!!", gender: "male", age: 21, location: "Queens, New York", email: "email@email.com", username: "jon_username", password: "password", token: "token")

    var userList = [User]()

    
    override func viewDidAppear(_ animated: Bool) {
        
        //https://www.hackingwithswift.com/read/22/2/requesting-location-core-location
        //location services
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        switch CLLocationManager.authorizationStatus() {
        //ask for permission. note: iOS only lets you ask once
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
        //show an alert if they said no last time
        case .authorizedWhenInUse, .restricted, .denied:
            let alertController = UIAlertController(
                title: "Background Location Access Disabled",
                message: "In order to optimize your matching experience please enable location services",
                preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
                if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                    UIApplication.shared.open(URL(string: "\(url)")!)
                    
                }
            }
            alertController.addAction(openAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        case .authorizedAlways:
            // just needed something in this switch
            print("thanks! for letting us see your location")
        }
        
    }

    override func viewDidLoad() {
       super.viewDidLoad()
       
        self.userEmail = appDelegate.userEmail
       // Do any additional setup after loading the view, typically from a nib.

        // https://stackoverflow.com/questions/32855753/i-want-to-swipe-right-and-left-in-swift
        // https://stackoverflow.com/questions/31785755/when-im-using-uiswipegesturerecognizer-im-getting-thread-1signal-sigabrt
        
        getUserId(completion: {id in
            self.userId = id
        })
        
        let swipeLeft : UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(MatchingViewController.swipeNewMatch(_:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left

        let swipeRight : UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "swipeNewMatch:")
        swipeRight.direction = UISwipeGestureRecognizerDirection.right

        self.view.addGestureRecognizer(swipeLeft)
        self.view.addGestureRecognizer(swipeRight)

        // closures: https://stackoverflow.com/questions/45925661/unexpected-non-void-return-value-in-void-function-swift3
        userList = getUsers(completion: { list in
                self.userList = list
                self.changeDisplayedUser()
        })
   }

    func downloadImage(_ uri : String, inView: UIImageView){

        let url = URL(string: uri)

        let task = URLSession.shared.dataTask(with: url!) {responseData,response,error in
            if error == nil{
                if let data = responseData {

                    DispatchQueue.main.async {
                        inView.image = UIImage(data: data)
                    }

                }else {
                    print("no data")
                }
            }else{
                print("Error")
            }
        }

        task.resume()

    }

    func getUsers( completion: @escaping ([User])->()) -> [User]{
        let rootUrl: String = appDelegate.rootUrl
        var usersList = [User]()
        
        let params : [String: Any]
        
        if (rootUrl == "http://localhost:9090/") {
           params = [
                "email": self.userEmail,
                "location": [                    -147.349442,
                                                 64.751114]
            ]
        } else {
            params = [
                "email": self.userEmail,
                "location": [
                    -147.349442,
                    64.751114
                ],
            ]
        }

        let url = rootUrl + "api/users"

        var headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        let _request = Alamofire.request(url, method: .get, parameters: params)
            .responseJSON { response in
                switch response.result {
                case .success:
                    if let jsonResult = response.result.value as? [[String:Any]] {
                        for jsonUser in jsonResult {
                            do {
                                let user = try User(json: (jsonUser["user"] as? [String:Any])!)
                                if (user != nil) {
                                    usersList.append(user!)
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
        return usersList
    }
    
    func getUserId( completion: @escaping (String)->()) {
        let rootUrl: String = appDelegate.rootUrl
        let url = rootUrl + "api/getuser"
        
        let params : [String:Any] = [
            "email": userEmail
        ]
        let _request = Alamofire.request(url, method: .post, parameters: params)
            .responseJSON { response in
                switch response.result {
                case .success:
                    if let jsonUser = response.result.value as? [String:Any] {
                            do {
                                let user = try User(json: (jsonUser as [String:Any]))
                                if (user != nil) {
                                    print("user")
                                    print(user!)
                                    completion((user?.id)!)
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
            if (current_index > 0) {
                current_index = current_index - 1
            }
            else {
                current_index = size - 1
            }
        case UISwipeGestureRecognizerDirection.left:
            print("SWIPED left")
            if (current_index < size-1) {
                current_index = current_index + 1
            }
            else {
                current_index = 0
            }
     
        default:
            break
        }
        changeDisplayedUser()

    }
    
    func changeDisplayedUser() {
        if (current_index >= 0 && current_index < userList.count) {
        nameLabel.text = userList[current_index].firstName! + ","
        self.downloadImage(userList[current_index].imageURL, inView: imageView)
        
        ageLabel.text = String(describing: userList[current_index].age)
        locationLabel.text = String(describing: userList[current_index].location)
        bioLabel.text = userList[current_index].bio
        
        let data = (self.userList[self.current_index].data as! [String:Any])
       
        if (data["totalMilesRun"] != nil) {
            self.milesLabel.text = String(describing: self.userList[self.current_index].data!["totalMilesRun"]!)
        } else {
            self.milesLabel.text = "No info to show"
        }
        
        if (data["AveragePace"] != nil) {
            self.avgPaceLabel.text = String(describing: self.userList[self.current_index].data!["AveragePace"]!)
        } else {
            self.avgPaceLabel.text = "No info to show"
        }
        }
    }
    
    
    func sendRequest(completion: @escaping (String, String)->()) {
        
        let rootUrl: String = appDelegate.rootUrl
        
        // alamofire request
        let params: [String: Any] = [
            "userId": self.userId,
            "targetId": userList[current_index].id!
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
                        title = "You matched with \(self.userList[self.current_index].firstName!)"
                        message = "Go to your chat to say hello!"
                    } else {
                        title = "Your request to \(self.userList[self.current_index].firstName!) has been sent!"
                        message = "Keep running!"
                    }
                case .failure(let error):
                    print("error fetching users")
                    print(error)
                }
        completion(title, message)
        }
        
    }

    @IBAction func matchButton(_ sender: UIButton) {

        print("You clicked match.")
        
        if (current_index > userList.count || userList.count == 0) {
            let alertController = UIAlertController(title: "Sorry!", message: "No matches at this time. Try again later", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "Refresh users", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
            //static right now,
            // will add a GET request when "refresh user" is clicked once backend is fixed
        }
        else {
        
        sendRequest(completion: { title, message in
            //https://www.simplifiedios.net/ios-show-alert-using-uialertcontroller/
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "Close", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
            })
        }
    }

//    func fetchUsers() {
//
//        //var dic=NSDictionary()
//
////        let params: Parameters = [
////            "email": email!,
////            "username": username!,
////            "password": password!
////        ]
//
//        let _request = Alamofire.request(Url, method: .g, parameters: params, encoding: URLEncoding.httpBody)
//            .responseJSON { response in
//                switch response.result {
//                case .success:
//                    print("Post Successful")
//                    //dic=(response.result.value) as! NSDictionary
//
//                    //var error = NSInteger()
//                    //error=dic.object(forKey: "error") as! NSInteger
//
//                case .failure(let error):
//                    print(error)
//                }
//        }
//        debugPrint("whole _request ****",_request)
//    }


}
