//
//  SafeTrackViewController.swift
//  RunningMates
//
//  Created by Sara Topic on 25/04/2018.
//  Copyright © 2018 Apple Inc. All rights reserved.
//

import GoogleMaps

//https://developers.google.com/maps/documentation/ios-sdk/start
class SafeTrackViewController: UIViewController {
    
    // You don't need to modify the default init(nibName:bundle:) method.
    
    @IBOutlet weak var mapViewArea: UIView!
    
    override func loadView() {
        // Create a GMSCameraPosition that tells the map to display the
        super.loadView()
        // coordinate -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        let rect = CGRect(
            origin: CGPoint(x: 0, y: 0),
            size: CGSize(width: 245, height: 245)
        )
        let mapView = GMSMapView.map(withFrame: rect, camera: camera)
        //var mapView = GMSMapView.mapWithFrame(CGRectMake(0, 0, 100, 100), camera: camera)
        mapView.isMyLocationEnabled = true
        self.mapViewArea = mapView
        //mapViewArea = mapView
       // view.addSubview(mapView)
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
    }
}
