//  MatchingViewController.swift
//  Running Mates
//
//  Created by Divya Kalidindi on 2/15/18.
//  Copyright © 2018 Divya Kalidindi. All rights reserved.
//
import UIKit
import Alamofire
import CoreLocation
import Koloda
import EMAlertController
import ImgixSwift

class MatchingViewController: UIViewController, UIGestureRecognizerDelegate, CLLocationManagerDelegate {
    // MARK: Properties
    var locationManager: CLLocationManager!
    var locationCoords: [Double]?
    var loadingView: MatchesLoadingView!
    @IBOutlet weak var kolodaView: KolodaView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    var current_index: Int!
    var location = ""
    
    var userId: String = ""
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    // var userEmail1: String! = UserDefaults.standard.string(forKey: "email")
    var userEmail: String! = UserDefaults.standard.string(forKey: "email")
    var preferences: [String: Any]! = UserDefaults.standard.value(forKey: "preferences") as! [String : Any]
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var milesLabel: UILabel!
    @IBOutlet weak var avgPaceLabel: UILabel!
    @IBOutlet var topView: GradientView!
    
    var userList = [sortedUser]()
    let client = ImgixClient.init(host: "runningmates.imgix.net")

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        // Show progress view while we wait for matches to load
        switch CLLocationManager.authorizationStatus() {
        //ask for permission. note: iOS only lets you ask once
        case .notDetermined:
            let canAsk = locationManager //.requestAlwaysAuthorization()
            if (canAsk != nil){
                 locationManager.requestAlwaysAuthorization()
            }
            else{
                showLocationDisabledPopup()
            }
            
        
        //show an alert if they said no last time
        case .authorizedWhenInUse, .restricted, .denied:
            getCurrentLocation()
            //            showLocationDisabledPopup()
            // locationManager.startUpdatingLocation()
            
        case .authorizedAlways:
            getCurrentLocation()
            // just needed something in this switch
            // locationManager.startUpdatingLocation()
            // self.kolodaView?.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        kolodaView.dataSource = self
        kolodaView.delegate = self
        
        self.navigationController?.isNavigationBarHidden = false
        
        
        self.userId = UserDefaults.standard.string(forKey: "id")!
        
        // Do any additional setup after loading the view, typically from a nib.
        // https://stackoverflow.com/questions/32855753/i-want-to-swipe-right-and-left-in-swift
        // https://stackoverflow.com/questions/31785755/when-im-using-uiswipegesturerecognizer-im-getting-thread-1signal-sigabrt
        loadingView = MatchesLoadingView().fromNib() as! MatchesLoadingView
        topView.addSubview(loadingView)
        loadingView.progressIndicator.startAnimating()
        
        //        navigationController?.setToolbarHidden(false, animated: false)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status == CLAuthorizationStatus.denied) {
            // The user denied authorization
            showLocationDisabledPopup()
        } else if (status == CLAuthorizationStatus.authorizedAlways) {
            //loadMatches()
        } else {
            print("authorized when in use")
            // loadMatches()
        }
    }
    
    
    
    func showForeverAlonePopup() {
        // closures: https://stackoverflow.com/questions/45925661/unexpected-non-void-return-value-in-void-function-swift3
        
        //https://www.hackingwithswift.com/read/22/2/requesting-location-core-location
        //location services
        
        if (self.current_index != nil && self.current_index >= self.userList.count || self.userList.count == 0) {
            let alert = EMAlertController(title: "Uh oh!", message: "There's no one new around you.")
            let icon = UIImage(named: "thumbsdown")
            
            alert.iconImage = icon
            
            let cancel = EMAlertAction(title: "Cancel", style: .cancel)
            let confirm = EMAlertAction(title: "Refresh", style: .normal) {
                self.loadingView = MatchesLoadingView().fromNib() as! MatchesLoadingView
                self.topView.addSubview(self.loadingView)
                self.loadingView.center = self.view.center
                self.loadingView.progressIndicator.startAnimating()
                self.locationManager.startUpdatingLocation()
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
                let params : [String:Any] = [
                    "location": [
                        lat,
                        long
                    ],
                    "email": self.userEmail
                ]
                
                UserManager.instance.requestUserUpdate(userEmail: self.userEmail, params: params, completion: {
                    (title, message) in
                    self.loadMatches()
                } )
            } else {
                print("No coordinates")
            }
        }
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        manager.stopUpdatingLocation()
    }
    
    func loadMatches() {
        
        let maxDistance = self.preferences["proximity"] as! Double
        
        //        if (lat != nil && long != nil) {
        UserManager.instance.requestPotentialMatches(userEmail: self.userEmail, maxDistance: maxDistance, completion: { list in
            
            //UserDefaults.standard.set(list, forKey: "userList")
            self.userList = list
            self.kolodaView?.reloadData()
            
            self.loadingView.removeFromSuperview()
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Actions
    @IBAction func filterButtonPressed(_ sender: UIBarButtonItem) {
        
        //            let  vc = self.storyboard?.instantiateViewController(withIdentifier: "Matching") as! UINavigationController
        //            self.present(vc, animated: true, completion: nil)
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "Filter") as? FilterViewController
        {
            present(vc, animated: true, completion: nil)
        }
        //self.navigationController?.popToRootViewController(animated: true)
        
    }
    @IBAction func leftButtonTapped() {
        kolodaView?.swipe(.left)
    }
    
    @IBAction func rightButtonTapped() {
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
                if message == "Go to your chat to say hello!" {
                    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "Close", style: .default, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            })
        }
    }
}

extension MatchingViewController: KolodaViewDelegate {
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        koloda.reloadData()
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        
        UserDefaults.standard.set(Int(index), forKey: "clickedUserIndex")
        UserDefaults.standard.set(location, forKey: "distanceAway")
        performSegue(withIdentifier: "profileDetail", sender: nil)
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
        let view: MatchingCardView = MatchingCardView().fromNib() as! MatchingCardView
        
        if (userList.count > 0 && index < userList.count) {
            if let images = userList[index].user.images as? [String]{
                if (images.count > 0){
                    if let url = URL(string: images[0]) {
                        
                        // imgix stuff - currently not working
                        let imgixURL = client.buildUrl(images[0], params: [
                            "width": "300",
                            "height": "300",
                            "fit" : "crop",
                            "crop": "entropy"])
                        let imgixPhotoData = try? Data(contentsOf: imgixURL)
                        
                        // this line currently fails
                        // let imgixImage = UIImage(data: imgixPhotoData!)

                        
                        let photoData = try? Data(contentsOf: url) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                        let image = UIImage(data: photoData!)
                        
                        view.profileImage.image = image
                    }
                }
            }
        }
        
        let nameAge = (String(userList[index].user.firstName!) + ", " + String(userList[index].user.age))
        
        let thirdPartyIds = userList[index].user.thirdPartyIds
        
        // Calculate potential match's distance from user
        let userLocation = self.locationCoords
        let matchLocation = [Double(userList[index].user.location[0]), Double(userList[index].user.location[1])]
        
        if (self.locationCoords != nil && self.locationCoords![0] != nil && self.locationCoords![1] != nil) {
            var distance = getDistanceInMeters(userLocation: userLocation!, matchLocation: matchLocation)
            if (distance < 1609) {
                location = "1 mile away"
            } else {
                let distanceInMi = distance / 1609
                location = String(round(distanceInMi)) + " miles away"
            }
            
            view.locationText.text! = location
        } else {
            view.locationText.text! = ""
        }
        
        let bio = (String(userList[index].user.bio))
        let data = (self.userList[index].user.data )
        
        let  totalMiles: String, averageRunLength: String, matchReason: String
        let totalMilesRun: String
        if (data!["runsPerWeek"] != nil) {
            
            var totalRunsString = String(describing: userList[index].user.data!["runsPerWeek"]!)
            var TotalRunsDouble  = Double(totalRunsString)!
            totalMilesRun = ("Runs/Week: " + String(format: "%.0f", TotalRunsDouble) + " runs")
        } else {
            totalMilesRun = "Runs/Week: No info to show"
        }
        
        if (data!["averageRunLength"] != nil) {
            averageRunLength = ("Avg. Run Length: " + String(describing: userList[index].user.data!["averageRunLength"]!) + " mi")
        } else {
            averageRunLength = "Avg. Run Length: No info to show"
        }
        
        
        view.locationText.text = location
        view.nameText.text! = nameAge
        view.bioText.text! = bio
        view.averageRunLengthText.text! = averageRunLength
        view.totalMilesText.text! = totalMilesRun
        
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
        if (direction == SwipeResultDirection.right) {
            tryMatch(index: index)
        }
        
        current_index = index + 1
        showForeverAlonePopup()
        
        if (index >= userList.count) {
            current_index = 0
        }
    }
    
    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
        return Bundle.main.loadNibNamed("MatchingCardOverlay", owner: self, options: nil)?[0] as? OverlayView
    }
}

