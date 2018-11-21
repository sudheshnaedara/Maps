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
    }
    
    func initializeMapVIew() {
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 5.0)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        mapView?.delegate = self
        mapView?.isMyLocationEnabled = true
        let source = GMSMarker()
        let destination = GMSMarker()
        source.position = CLLocationCoordinate2D(latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!)
        destination.position = CLLocationCoordinate2D(latitude: 13.0196, longitude: 77.5968)
        source.map = mapView
        destination.map = mapView
        getPolylineRoute(from: source.position, to: destination.position)
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
      location = locations.first
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude:(location?.coordinate.longitude)!, zoom:14)
    initializeMapVIew()
        mapView?.animate(to: camera)
        self.locationManager.stopUpdatingLocation()
    }
}
