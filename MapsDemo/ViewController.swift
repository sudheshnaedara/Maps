//
//  ViewController.swift
//  MapsDemo
//
//  Created by SparkMac on 19/11/18.
//  Copyright © 2018 Infosys. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate , GMSMapViewDelegate{
    
    var locationManager: CLLocationManager!
    var mapView: GMSMapView?
    var location: CLLocation?
    let path = GMSMutablePath()
    var route = GMSPolyline()
    var isfirstInitial: Bool = false
    
    override func loadView() {
         mapView = GMSMapView()
        self.view = GMSMapView(frame: UIScreen.main.bounds)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeTheLocationManager()
    }
    
    func initializeTheLocationManager() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
         locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
   
  func initializeMapVIew() {
        self.mapView?.isMyLocationEnabled = true
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 12.0)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        mapView?.delegate = self
        mapView?.isMyLocationEnabled = true
        mapView?.animate(to: camera)
    }
     func marker() {
        let position = CLLocationCoordinate2D(latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!)
        let marker = GMSMarker(position: position)
        marker.tracksViewChanges = true
        marker.appearAnimation = .pop
         marker.map = mapView
    }

    

  
}
