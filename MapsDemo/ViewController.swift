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

class ViewController: UIViewController {
    
    var mapView: GMSMapView?
    override func loadView() {
         mapView = GMSMapView()
        let camera = GMSCameraPosition.camera(withLatitude: 23.431351, longitude: 85.325879, zoom: 6.0)
      mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 23.431351, longitude: 85.325879)
        let destination = CLLocationCoordinate2D(latitude: 28.617220, longitude: 77.208099)
        marker.title = "Ranchi, Jharkhand"
        marker.map = mapView
        getPolylineRoute(from: marker.position, to: destination)
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
}
