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
    
    override func loadView() {
         mapView = GMSMapView()
        self.view = GMSMapView(frame: UIScreen.main.bounds)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeTheLocationManager()
        self.mapView?.isMyLocationEnabled = true
    }
    
    func initializeTheLocationManager() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        createButton() 
    }
    
    func createButton() {
    let buttonPuzzle:UIButton = UIButton(frame: CGRect(x: 100, y: 400, width: 200, height: 50))
        buttonPuzzle.backgroundColor = UIColor.green
        buttonPuzzle.setTitle("Start Location Monitoring", for: UIControlState.normal)
        buttonPuzzle.addTarget(self, action: #selector(myButtonTapped), for: UIControlEvents.touchUpInside)
        buttonPuzzle.tag = 1
    self.view.addSubview(buttonPuzzle)
}
    @objc func myButtonTapped(sender:UIButton!) {
        if sender.tag == 1 {
            locationManager.startUpdatingLocation()
            initializeMapVIew(sender: sender)
            sender.setTitle("Stop Monitoring Location", for: .normal)
             sender.tag = 2
        }else {
            locationManager.stopUpdatingLocation()
            sender.setTitle("Start Monitoring Location", for: .normal)
            sender.tag = 1
        }
    }
    
    func initializeMapVIew(sender: UIButton) {
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 5.0)
        mapView = GMSMapView.map(withFrame: CGRect(x: 100, y: 100, width: 200, height: 200), camera: camera)
//      mapView?.center = self.view.center
        
        self.view.addSubview(mapView!)
        
//        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
//   view = mapView
        mapView?.delegate = self
        mapView?.isMyLocationEnabled = true
        let source = GMSMarker()
        let destination = GMSMarker()
        source.position = CLLocationCoordinate2D(latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!)
        destination.position = CLLocationCoordinate2D(latitude: 13.0196, longitude: 77.5968)
        source.map = mapView
        destination.map = mapView
        if sender.tag == 1 {
        }else {
            print("stopped monitoring ")
        }
    }
    

  
}
