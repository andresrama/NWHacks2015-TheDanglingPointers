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
    let mgr = CLLocationManager()
    
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mojio = MojioClient.client() as? MojioClient
        
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
    }
}
