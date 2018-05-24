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
import EMAlertController


class MatchingViewController: UIViewController, UIGestureRecognizerDelegate, CLLocationManagerDelegate {
   // MARK: Properties
    var locationManager: CLLocationManager!
    var locationCoords: [Double]!
    var loadingView: MatchesLoadingView!
    @IBOutlet weak var kolodaView: KolodaView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    var current_index: Int!

    var userId: String = ""
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    // var userEmail1: String! = UserDefaults.standard.string(forKey: "email")
    var userEmail: String! = UserDefaults.standard.string(forKey: "email")
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var milesLabel: UILabel!
    @IBOutlet weak var avgPaceLabel: UILabel!
    @IBOutlet var topView: GradientView!

    var userList = [sortedUser]()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getCurrentLocation()
    }


    override func viewDidAppear(_ animated: Bool) {
        // Show progress view while we wait for matches to load
        switch CLLocationManager.authorizationStatus() {
        //ask for permission. note: iOS only lets you ask once
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
            
        //show an alert if they said no last time
        case .authorizedWhenInUse, .restricted, .denied:
            showLocationDisabledPopup()
            locationManager.startUpdatingLocation()
            
        case .authorizedAlways:
            // just needed something in this switch
            locationManager.startUpdatingLocation()
            self.kolodaView?.reloadData()
        }
    }

    override func viewDidLoad() {
       super.viewDidLoad()

        kolodaView.dataSource = self
        kolodaView.delegate = self


        UserManager.instance.requestUserObject(userEmail: self.userEmail, completion: {user in
            self.userId = user.id!
        })

       // Do any additional setup after loading the view, typically from a nib.

        // https://stackoverflow.com/questions/32855753/i-want-to-swipe-right-and-left-in-swift
        // https://stackoverflow.com/questions/31785755/when-im-using-uiswipegesturerecognizer-im-getting-thread-1signal-sigabrt
        loadingView = MatchesLoadingView().fromNib() as! MatchesLoadingView
        topView.addSubview(loadingView)
        loadingView.progressIndicator.startAnimating()

        locationManager = CLLocationManager()
        locationManager.delegate = self
   }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status == CLAuthorizationStatus.denied) {
            // The user denied authorization
            print("not authorized")
            showLocationDisabledPopup()
        } else if (status == CLAuthorizationStatus.authorizedAlways) {
            print("authorized")
        } else {
            print("authorized when in use")
        }
    }
    
    func showForeverAlonePopup() {
        // closures: https://stackoverflow.com/questions/45925661/unexpected-non-void-return-value-in-void-function-swift3
        
        //https://www.hackingwithswift.com/read/22/2/requesting-location-core-location
        //location services
        print("showing popup")
        print(self.userList.count)
        print(self.current_index)
        
        if (self.current_index != nil && self.current_index >= self.userList.count || self.userList.count == 0) {
            let alert = EMAlertController(title: "Uh oh!", message: "There's no one new around you. Looks like you're gonna die alone.")
            let icon = UIImage(named: "thumbsdown")
            
            alert.iconImage = icon
            
            let cancel = EMAlertAction(title: "Cancel", style: .cancel)
            let confirm = EMAlertAction(title: "Refresh", style: .normal) {
                // Perform Action
            }
            
            alert.addAction(action: cancel)
            alert.addAction(action: confirm)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showLocationDisabledPopup() {
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
    }

    // adapted the following 2 functions from the following URL on 5/21/18:
    // http://swiftdeveloperblog.com/code-examples/determine-users-current-location-example-in-swift/

    func getCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest

        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            //locationManager.startUpdatingHeading()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if let location = locations[locations.count - 1] as? CLLocation {


            if let lat = location.coordinate.latitude as? Double, let long = location.coordinate.longitude as? Double {
                self.locationCoords = [lat, long]

                let testerLocation =  [Double(-147.349442), Double(64.751114)]
                let params : [String:Any] = [
                    "location": [
                        lat,
                        long
                    ]
                ]

                UserManager.instance.requestUserUpdate(userEmail: self.userEmail, params: params, completion: {
                    (title, message) in
                    print("updated location")
                } )

                UserManager.instance.requestPotentialMatches(userEmail: self.userEmail, location: testerLocation, completion: { list in
                    self.userList = list
                    self.kolodaView?.reloadData()
                    self.loadingView.removeFromSuperview()
                    self.showForeverAlonePopup()
                })
            } else {
                print("No coordinates")
            }
        }

        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        manager.stopUpdatingLocation()
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

   override func didReceiveMemoryWarning() {
       super.didReceiveMemoryWarning()
       // Dispose of any resources that can be recreated.
   }

   //MARK: Actions

    @IBAction func leftButtonTapped() {
        print("swipe left", current_index, userList[current_index].user.firstName)

//        if (current_index > 0) {
//            current_index = current_index - 1
//        }
//        else {
//            current_index = userList.count - 1
//        }

        kolodaView?.swipe(.left)
    }

    @IBAction func rightButtonTapped() {
        print("swipe right")
        kolodaView?.swipe(.right)

    }

    @IBAction func undoButtonTapped() {
        kolodaView?.revertAction()
    }

    func tryMatch(index currentIndex: Int) {

        if (currentIndex != nil && currentIndex > userList.count || userList.count == 0) {
            let alertController = UIAlertController(title: "Sorry!", message: "No matches at this time. Try again later", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "Refresh users", style: .default, handler: nil)
            alertController.addAction(defaultAction)

            self.present(alertController, animated: true, completion: nil)
            //static right now,
            // will add a GET request when "refresh user" is clicked once backend is fixed
        }
    else {

            UserManager.instance.sendMatchRequest(userId: self.userId, targetId: userList[currentIndex].user.id!, firstName: self.userList[currentIndex].user.firstName!, completion: { title, message in
            //https://www.simplifiedios.net/ios-show-alert-using-uialertcontroller/
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "Close", style: .default, handler: nil)
            alertController.addAction(defaultAction)

            self.present(alertController, animated: true, completion: nil)
            })
        }
    }
}

extension MatchingViewController: KolodaViewDelegate {
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        koloda.reloadData()
    }

}
extension MatchingViewController: KolodaViewDataSource {

    func kolodaNumberOfCards(_ koloda:KolodaView) -> Int {
        return userList.count

    }

    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .default
    }

    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        print("the current index is", index)
        print(userList[index].user.firstName!)

        let url = URL(string: userList[index].user.imageURL)
        let photoData = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch

        let image = UIImage(data: photoData!)
        let nameAge = (String(userList[index].user.firstName!) + ", " + String(userList[index].user.age))


        // Calculate potential match's distance from user
        var location = ""
        let userLocation = self.locationCoords
        var matchLocation = [Double(userList[index].user.location[0]), Double(userList[index].user.location[1])]

        print("locations: " + String(describing: userLocation) + " " + String(describing: matchLocation))

        var distance = getDistanceInMeters(userLocation: userLocation!, matchLocation: matchLocation)
        if (distance < 1609) {
            location = "< 1 mi away"
        } else {
            let distanceInMi = distance / 1609
            location = String(round(distanceInMi)) + " mi away"
        }

        let bio = (String(userList[index].user.bio))
        let data = (self.userList[index].user.data )

        let  totalMiles: String, averageRunLength: String, matchReason: String
        if (data!["totalMilesRun"] != nil) {
            totalMiles = ("Total Miles: " + String(describing: userList[index].user.data!["totalMilesRun"]!) + " mi")
        } else {
            totalMiles = "Total Miles: No info to show"
        }

        if (data!["averageRunLength"] != nil) {
            averageRunLength = ("Avg. Run Length: " + String(describing: userList[index].user.data!["averageRunLength"]!) + " mi")
        } else {
            averageRunLength = "Avg. Run Length: No info to show"
        }

        //let userText = nameAge + location + bio + totalMiles + averageRunLength

        let view: MatchingCardView = MatchingCardView().fromNib() as! MatchingCardView

        view.profileImage.image = image!
        view.nameText.text! = nameAge
        view.bioText.text! = bio
        view.averageRunLengthText.text! = averageRunLength
        view.totalMilesText.text! = totalMiles
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        view.clipsToBounds = true


        if (userList[index].matchReason != "") {
            matchReason = ("\n Reason to Match: " + (userList[index].matchReason as! String))
        } else {
            matchReason = "\n"
        }

        return view
    }

    func getDistanceInMeters(userLocation: [Double], matchLocation: [Double]) -> Double {
        let coordinate1 = CLLocation(latitude: CLLocationDegrees(userLocation[1]), longitude: CLLocationDegrees(userLocation[0]))
        let coordinate2 = CLLocation(latitude: CLLocationDegrees(matchLocation[1]), longitude: CLLocationDegrees(matchLocation[0]))


        let distanceInMeters = coordinate1.distance(from: coordinate2)
        return distanceInMeters.magnitude
    }

    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection){
            print("swiped card at", index, "in direction", direction)
        if (direction == SwipeResultDirection.right) {
            tryMatch(index: index)
        }

        current_index = index + 1
        showForeverAlonePopup()
        
        if (index >= userList.count) {
            current_index = 0
        }
//        print("currently looking at", userList[current_index].user.firstName)
        showForeverAlonePopup()
    }

    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
        return Bundle.main.loadNibNamed("MatchingCardOverlay", owner: self, options: nil)?[0] as? OverlayView
    }
}
