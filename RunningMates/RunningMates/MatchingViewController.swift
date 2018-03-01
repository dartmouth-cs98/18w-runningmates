//
//  ViewController.swift
//  FoodTracker
//
//  Created by Divya Kalidindi on 2/15/18.
//  Copyright © 2018 Divya Kalidindi. All rights reserved.
//

import UIKit
import Alamofire

class MatchingViewController: UIViewController, UIGestureRecognizerDelegate {

   // MARK: Properties

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    var current_index = 0
    var rootURl: String = "http://localhost:9090/"
//    var rootURl: String = "https://running-mates.herokuapp.com/"

    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!

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


    override func viewDidLoad() {
       super.viewDidLoad()
       // Do any additional setup after loading the view, typically from a nib.

        // https://stackoverflow.com/questions/32855753/i-want-to-swipe-right-and-left-in-swift
        // https://stackoverflow.com/questions/31785755/when-im-using-uiswipegesturerecognizer-im-getting-thread-1signal-sigabrt
        let swipeLeft : UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "swipeNewMatch:")
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left

        let swipeRight : UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "swipeNewMatch:")
        swipeRight.direction = UISwipeGestureRecognizerDirection.right

        self.view.addGestureRecognizer(swipeLeft)
        self.view.addGestureRecognizer(swipeRight)

        // closures: https://stackoverflow.com/questions/45925661/unexpected-non-void-return-value-in-void-function-swift3
        userList = getUsers(completion: { list in
                self.userList = list
                if (self.userList.count > 0) {
                self.nameLabel.text = self.userList[0].firstName
                self.downloadImage(self.userList[0].imageURL, inView: self.imageView)
                self.ageLabel.text = String(self.userList[self.current_index].age)
                self.locationLabel.text = String(describing: self.userList[self.current_index].location)
                self.bioLabel.text = self.userList[self.current_index].bio
            }
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
        var usersList = [User]()

        let params: [String: Any] = [
            "username": "drew",
            "location": [43.7022, 72.2896]
        ]


        let url = rootURl + "api/users"

        var headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        let _request = Alamofire.request(url, method: .get, parameters: params)
            .responseJSON { response in
                switch response.result {
                case .success:
                    if let jsonResult = response.result.value as? [[String:Any]] {
                        for jsonUser in jsonResult {
                                print("jsonUser:")
                                print(jsonUser)
                            let user = User(json: jsonUser)
                            if (user != nil) {
                                usersList.append(user!)
                            } else {
                                print("nil")
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
            //do nothing if swipe right?
        case UISwipeGestureRecognizerDirection.left:
            print("SWIPED left")
            if (current_index < size-1) {
                current_index = current_index + 1
            }
            else {
                current_index = 0
            }
            nameLabel.text = userList[current_index].firstName
            self.downloadImage(userList[current_index].imageURL, inView: imageView)

            ageLabel.text = String(userList[current_index].age)
            locationLabel.text = String(describing: userList[current_index].location)
            bioLabel.text = userList[current_index].bio


        default:
            break
        }

    }

    @IBAction func matchButton(_ sender: UIButton) {

        print("You clicked match.")
        
        // alamofire request
        let params: [String: Any] = [
            "requestingUser": "fdsfasd",
            "requestedUser": "fdsaf"
        ]
        
        let url = rootURl + "api/users"
        
        let _request = Alamofire.request(url, method: .post, parameters: params)
            .responseJSON { response in
                switch response.result {
                case .success:
                    print("success")
                case .failure(let error):
                    print("error fetching users")
                    print(error)
                }
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
