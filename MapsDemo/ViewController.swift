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
        getPolylineRoute(from: source.position, to: destination.position)
        }else {
            print("stopped monitoring ")
        }
    }
    
func getPolylineRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D){
    
    let config = URLSessionConfiguration.default
    let session = URLSession(configuration: config)
    
    let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(source.latitude),\(source.longitude)&destination=\(destination.latitude),\(destination.longitude)&sensor=false&mode=driving"+"&key=" + "AIzaSyAqD2eTrMdjf2DFqGKQZ4sw9oILyt0xRnQ")!
    
    let task = session.dataTask(with: url, completionHandler: {
        (data, response, error) in
        if error != nil {
            print(error!.localizedDescription)
        }else{
            do {
                if let json : [String:Any] = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]{
                    
                    let preRoutes = json["routes"] as! NSArray
                    let routes = preRoutes[0] as! NSDictionary
                    let routeOverviewPolyline:NSDictionary = routes.value(forKey: "overview_polyline") as! NSDictionary
                    let polyString = routeOverviewPolyline.object(forKey: "points") as! String
                    
                    DispatchQueue.main.async(execute: {
                        let path = GMSPath(fromEncodedPath: polyString)
                        let polyline = GMSPolyline(path: path)
                        polyline.strokeWidth = 5.0
                        polyline.strokeColor = UIColor.green
                        polyline.map = self.mapView
                    })
                }
            }catch{
                print("error in JSONSerialization")
            }
        }
    })
    task.resume()
}

   func locationManager(_ manager:CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
//    for eachLocation in locations {
//        location = eachLocation
//        print("Each location Updates\(String(describing: location))")
//    }
     location = locations.first
    print("Each location Updates\(String(describing: location))")
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude:(location?.coordinate.longitude)!, zoom:14)
        mapView?.animate(to: camera)
//        self.locationManager.stopUpdatingLocation()
    }
}
