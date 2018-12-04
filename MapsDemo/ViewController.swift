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

     func locationManager(_ manager:CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      location = locations.first
    if isfirstInitial == false {
    initializeMapVIew()
    self.marker()
        isfirstInitial = true
    }
    let locationsArray = locations as NSArray
    let locationObject = locationsArray.lastObject as? CLLocation
    if (locationObject != nil) {
    self.locationManager.stopUpdatingLocation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.locationManager.startUpdatingLocation()
                for coor in locations {
                    self.path.add(CLLocationCoordinate2D(latitude: coor.coordinate.latitude, longitude: coor.coordinate.longitude))
                    print("path\(self.path.count())")
                        }
                }
        }
    route = GMSPolyline.init(path: path)
    route.strokeWidth = 5.0
    route.strokeColor = UIColor.green
    route.geodesic = true
   route.map = mapView
    self.view = mapView
    }
   
func locationManager(_manager: CLLocationManager, didFailWithError error: Error) {
    print(error.localizedDescription)
}

  
}
