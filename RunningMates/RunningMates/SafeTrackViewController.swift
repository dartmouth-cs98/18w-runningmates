//
//  SafeTrackViewController.swift
//  RunningMates
//
//  Created by Sara Topic on 25/04/2018.
//  Copyright © 2018 Apple Inc. All rights reserved.
//

import GoogleMaps
import GooglePlaces
//https://developers.google.com/maps/documentation/ios-sdk/current-place-tutorial?_ga=2.22727355.1009863734.1525292435-164906073.1524505865
//https://developers.google.com/maps/documentation/ios-sdk/start
//https://stackoverflow.com/questions/44847866/swift-3-google-maps-how-to-update-marker-on-the-map
class SafeTrackViewController: UIViewController,  CLLocationManagerDelegate {
    
    // You don't need to modify the default init(nibName:bundle:) method.
    
   
    @IBOutlet weak var unsafeButton: UIButton!
    @IBOutlet weak var safeButton: UIButton!
    @IBOutlet weak var runCompleteButton: UIButton!
    
    @IBOutlet weak var mapView: GMSMapView!
    var marker: GMSMarker!

    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var zoomLevel: Float = 15.0
    
    override func loadView() {
        super.loadView()

        self.unsafeButton.layer.cornerRadius = 20;
        self.unsafeButton.clipsToBounds = true;
        self.unsafeButton.layer.borderColor = UIColor.black.cgColor
        self.unsafeButton.layer.borderWidth = 1

        self.safeButton.layer.cornerRadius = 20;
        self.safeButton.clipsToBounds = true;
        self.safeButton.layer.borderColor = UIColor.black.cgColor
        self.safeButton.layer.borderWidth = 1

        
        self.runCompleteButton.layer.cornerRadius = 20;
        self.runCompleteButton.clipsToBounds = true;
        self.runCompleteButton.layer.borderColor = UIColor.black.cgColor
        self.runCompleteButton.layer.borderWidth = 1

    }
    override func viewDidLoad() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        
        let camera = GMSCameraPosition.camera(withLatitude: +31.75097946, longitude: +35.23694368, zoom: 17.0)
        
        self.mapView.camera = camera
        marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: +31.75097946, longitude: +35.23694368)
        marker.title = "some text"
        marker.map = self.mapView
        marker.opacity = 1.0

    
}
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations
        locations: [CLLocation]) {
        print("*********did update locations")
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        
         marker.position = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
 
        let camera = GMSCameraPosition.camera(withTarget: marker.position, zoom: 17.0)
        mapView.camera = camera

//        marker.snippet = "Australia"
        
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
}
    
}
