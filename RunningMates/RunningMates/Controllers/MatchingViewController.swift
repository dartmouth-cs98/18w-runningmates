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
import Koloda


class MatchingViewController: UIViewController, UIGestureRecognizerDelegate, CLLocationManagerDelegate {

   // MARK: Properties

    var locationManager: CLLocationManager!
    @IBOutlet weak var kolodaView: KolodaView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    var current_index: Int!
//    var rootURl: String = "http://localhost:9090/"
//    var rootURl: String = "https://running-mates.herokuapp.com/"
    var userId: String = ""
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var userEmail: String = UserDefaults.standard.string(forKey: "email")!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var milesLabel: UILabel!
    @IBOutlet weak var avgPaceLabel: UILabel!


    var userList = [sortedUser]()


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

        kolodaView.dataSource = self
        kolodaView.delegate = self

       // Do any additional setup after loading the view, typically from a nib.

        // https://stackoverflow.com/questions/32855753/i-want-to-swipe-right-and-left-in-swift
        // https://stackoverflow.com/questions/31785755/when-im-using-uiswipegesturerecognizer-im-getting-thread-1signal-sigabrt


        UserManager.instance.requestUserObject(userEmail: self.userEmail, completion: {user in
            self.userId = user.id!
        })


        // closures: https://stackoverflow.com/questions/45925661/unexpected-non-void-return-value-in-void-function-swift3
        UserManager.instance.requestPotentialMatches(userEmail: self.userEmail, location: [-147.349442, 64.751114], completion: { list in
            self.userList = list
            self.kolodaView?.reloadData()
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

<<<<<<< HEAD
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
        let request = Alamofire.request(url, method: .get, parameters: params)
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
                        print("error getting matches")
                        print(response.result.value)
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
        let url = rootUrl + "api/user/" + self.userEmail

        let params : [String:Any] = [
            "email": self.userEmail
        ]
        let _request = Alamofire.request(url, method: .get, parameters: params)
            .responseJSON { response in
                print("RESPONSE")
                print(response)
                switch response.result {
                case .success:
                    if let jsonUser = response.result.value as? [String:Any] {
                            do {
                                let user = try User(json: (jsonUser as [String:Any]))
                                if (user != nil) {
                                    print("USER")
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

=======
>>>>>>> 88d4032ff4c98d6f800a3d23ff5852f3444e87eb
   override func didReceiveMemoryWarning() {
       super.didReceiveMemoryWarning()
       // Dispose of any resources that can be recreated.
   }

   //MARK: Actions

    @IBAction func leftButtonTapped() {
        print("swipe left")
        kolodaView?.swipe(.left)

    }

    @IBAction func rightButtonTapped() {
        print("swipe right")
        kolodaView?.swipe(.right)

    }

    @IBAction func undoButtonTapped() {
        kolodaView?.revertAction()
    }
    // https://stackoverflow.com/questions/28696008/swipe-back-and-forth-through-array-of-images-swift?rq=1
//    @IBAction func swipeNewMatch(_ sender: UISwipeGestureRecognizer) {
//        let size = userList.count
//
//        switch sender.direction {
//        case UISwipeGestureRecognizerDirection.right:
//            print("SWIPED right")
//            if (current_index > 0) {
//                current_index = current_index - 1
//            }
//            else {
//                current_index = size - 1
//            }
//        case UISwipeGestureRecognizerDirection.left:
//            print("SWIPED left")
//            if (current_index < size-1) {
//                current_index = current_index + 1
//            }
//            else {
//                current_index = 0
//            }
//
//        default:
//            break
//        }
//        changeDisplayedUser()
//
//    }
//
//    func changeDisplayedUser() {
//        if (current_index >= 0 && current_index < userList.count) {
//        nameLabel.text = userList[current_index].firstName! + ","
//        self.downloadImage(userList[current_index].imageURL, inView: imageView)
//
//        ageLabel.text = String(describing: userList[current_index].age)
//        locationLabel.text = String(describing: userList[current_index].location)
//        bioLabel.text = userList[current_index].bio
//
//        let data = (self.userList[self.current_index].data as! [String:Any])
//
//        if (data["totalMilesRun"] != nil) {
//            self.milesLabel.text = String(describing: self.userList[self.current_index].data!["totalMilesRun"]!)
//        } else {
//            self.milesLabel.text = "No info to show"
//        }
//
//        if (data["AveragePace"] != nil) {
//            self.avgPaceLabel.text = String(describing: self.userList[self.current_index].data!["AveragePace"]!)
//        } else {
//            self.avgPaceLabel.text = "No info to show"
//        }
//        }
//    }


    func textToImage(drawText text: String, inImage image: UIImage, atPoint point: CGPoint) -> UIImage {
        let textColor = UIColor.black
        let textFont = UIFont(name: "Helvetica Bold", size: 14)!

        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(image.size, false, scale)

        let textFontAttributes = [
            NSAttributedStringKey.font: textFont,
            NSAttributedStringKey.foregroundColor: textColor,
            ] as [NSAttributedStringKey : Any]
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))

        let rect = CGRect(origin: point, size: image.size)
        text.draw(in: rect, withAttributes: textFontAttributes)

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }


    @IBAction func matchButton(_ sender: UIButton) {

        print("You clicked match on index", current_index)

        if (current_index > userList.count || userList.count == 0) {
            let alertController = UIAlertController(title: "Sorry!", message: "No matches at this time. Try again later", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "Refresh users", style: .default, handler: nil)
            alertController.addAction(defaultAction)

            self.present(alertController, animated: true, completion: nil)
            //static right now,
            // will add a GET request when "refresh user" is clicked once backend is fixed
        }
        else {

            UserManager.instance.sendMatchRequest(userId: self.userId, targetId: userList[current_index].user.id!, firstName: self.userList[self.current_index].user.firstName!, completion: { title, message in
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

extension MatchingViewController: KolodaViewDelegate {
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        koloda.reloadData()
    }

}
extension MatchingViewController: KolodaViewDataSource {

    func kolodaNumberOfCards(_ koloda:KolodaView) -> Int {
<<<<<<< HEAD
        print(userList)

        for user in userList{
            print(user.firstName)
        }
        print(self.userList)
=======
>>>>>>> 88d4032ff4c98d6f800a3d23ff5852f3444e87eb
        return userList.count

    }

    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .default
    }

    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        print("the current index is", current_index)
        // Need to create UIImage from URL string
        // let url = URL(string: self.userList[index].imageURL)
<<<<<<< HEAD
        //var user: Int;

        let url = URL(string: userList[index].imageURL)
=======
        let url = URL(string: userList[index].user.imageURL)
>>>>>>> 88d4032ff4c98d6f800a3d23ff5852f3444e87eb
        let photoData = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch

        let image = UIImage(data: photoData!)
        let nameAge = ("\n " + String(userList[index].user.firstName!) + ", " + String(userList[index].user.age))
        let location = ("\n Location: " + String(describing: userList[index].user.location))
        let bio = ("\n Bio: " + String(userList[index].user.bio))
        let data = (self.userList[index].user.data as! [String:Any]?)

        let  totalMiles: String, averageRunLength: String, matchReason: String
        if (data!["totalMilesRun"] != nil) {
            totalMiles = (" \n Total Miles: " + String(describing: userList[index].user.data!["totalMilesRun"]!))
        } else {
            totalMiles = "\n No info to show"
        }

        if (data!["averageRunLength"] != nil) {
            averageRunLength = ("\n Avg. Run Length: " + String(describing: userList[index].user.data!["averageRunLength"]!))
        } else {
            averageRunLength = "\n Avg. Run Length: No info to show"
        }


        if (userList[index].matchReason != nil) {
            matchReason = ("\n Reason to Match: " + (userList[index].matchReason as! String))
        } else {
            matchReason = "\n"
        }

        let userText = nameAge + location + bio + totalMiles + averageRunLength + matchReason
        let point = CGPoint(x: 0, y: 100)

        let userCardImage = textToImage(drawText:userText, inImage:image!, atPoint:point)

        if (index == 0){
            current_index = userList.count - 1
        }
        else if (index == 1){
            current_index = userList.count - 2
        }
        else if (index == userList.count - 1){
            current_index = 0
        }
        else if (index == userList.count - 2){
            current_index = 1
        }
        else{
            current_index = index - 2
        }

        return UIImageView(image: userCardImage)
    }

}
