//
//  MapViewController.swift
//  CarO2
//
//  Created by Ming Tang on 2015-03-28.
//  Copyright (c) 2015 Andres Rama. All rights reserved.
//

import CoreLocation
import MapKit
import UIKit
import Foundation

class MapViewController : UIViewController, CLLocationManagerDelegate {
    var mojio : MojioClient?
    var tripData : TripData?
    var annos : [MKPointAnnotation]? = nil
    let mgr = CLLocationManager()
    
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mojio = MojioClient.client() as? MojioClient
        
        self.tripData = TripData(mojio: self.mojio!, fuelEff: true, limit: 100)
        let tripData = self.tripData!
        
        var coord = CLLocationCoordinate2DMake(12.3, -45.6)
        var anno = MKPointAnnotation()
        anno.setCoordinate(coord)
        anno.title = "Hello, world!"
        
        mgr.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            mgr.startUpdatingLocation()
        }
        mapView.showsUserLocation = true
        mapView.addAnnotation(anno)
        
        tripData.getEvents() {
            let coords = filter(map(tripData.results!) {
                CLLocationCoordinate2DMake($0.Location.Lat, $0.Location.Lng)
                }) {
                    // Make sure the car is not in Africa
                    abs($0.latitude) + abs($0.longitude) > 0.1
            }
            
            self.annos = Array(map(tripData.results!) {
                (e : Event) in
                var anno = MKPointAnnotation()
                anno.setCoordinate(CLLocationCoordinate2DMake(e.Location.Lat, e.Location.Lng))
                anno.title = "Speed: \(e.Speed) km/h, Fuel Eff: \(e.FuelEfficiency) L/100km"
                return anno
            })
            
            
            let minLat = coords.map({ $0.latitude }).reduce(Double.infinity, { min($0, $1) })
            let maxLat = coords.map({ $0.latitude }).reduce(-Double.infinity, { max($0, $1) })
            let minLon = coords.map({ $0.longitude }).reduce(Double.infinity, { min($0, $1) })
            let maxLon = coords.map({ $0.longitude }).reduce(-Double.infinity, { max($0, $1) })
            let sp = MKCoordinateSpanMake(1.1*(maxLat - minLat), 1.1*(maxLon - minLon))
            let center = CLLocationCoordinate2DMake((minLat + maxLat)/2.0, (minLon + maxLon)/2.0)
            let reg = MKCoordinateRegionMake(center, sp)
            self.mapView.setRegion(reg, animated: true)
            
            for a in self.annos! {
                self.mapView.addAnnotation(a)
            }
        }
    }
    
        
    func handleFailure(err : NSError!) {
        println("Failure")
        println(err)
    }
}
