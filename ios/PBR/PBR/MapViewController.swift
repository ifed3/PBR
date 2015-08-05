//
//  MapViewController.swift
//  PBR
//
//  Created by Michael Hassin on 8/4/15.
//  Copyright (c) 2015 chihacknight. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView = MKMapView(frame: self.view.frame)
        mapView.delegate = self
        mapView.showsUserLocation = true
        self.view.addSubview(mapView)
    }
    
    override func viewDidAppear(animated: Bool) {
//        centerViewOnLocation(mapView.userLocation.location)
    }
    
    func centerViewOnLocation(location: CLLocation){
        let center = location.coordinate
        let span = MKCoordinateSpanMake(0.01, 0.01)
        let mapRegion = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(mapRegion, animated: true)
    }
    
    func displayRoute(origin: String, destination: String){
        GISUtils.getCoordinate(origin)
        GISUtils.getCoordinate(destination)
    }
}
