//
//  ViewController.swift
//  MapsDemo
//
//  Created by SparkMac on 19/11/18.
//  Copyright © 2018 Infosys. All rights reserved.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController {
    

    override func loadView() {
        var mapView = GMSMapView()
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
    
    let url = URL(string: "http://maps.googleapis.com/maps/api/directions/json?origin=\(source.latitude),\(source.longitude)&destination=\(destination.latitude),\(destination.longitude)&sensor=false&mode=driving")!
    
    let task = session.dataTask(with: url, completionHandler: {
        (data, response, error) in
        if error != nil {
            print(error!.localizedDescription)
        }else{
            do {
                if let json : [String:Any] = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]{
                    
                    let routes = json["routes"] as? [Any]
                    let overview_polyline = routes?[0] as?[String:Any]
                    let polyString = overview_polyline?["points"] as?String
                    
                    //Call this method to draw path on map
                    self.showPath(polyStr: polyString!)
                }
                
            }catch{
                print("error in JSONSerialization")
            }
        }
    })
    task.resume()
}
func showPath(polyStr :String){
    let path = GMSPath(fromEncodedPath: polyStr)
    let polyline = GMSPolyline(path: path)
    polyline.strokeWidth = 3.0
    //polyline.map = mapView // Your map view
}
}
