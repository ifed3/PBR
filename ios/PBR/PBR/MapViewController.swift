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
    var polyline: MKGeodesicPolyline!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView = MKMapView(frame: self.view.frame)
        mapView.delegate = self
//        mapView.showsUserLocation = true
        self.view.addSubview(mapView)
    }
    
    override func viewDidAppear(animated: Bool) {
        mapView.addOverlay(polyline)
    }
    
    func centerViewOnLocation(location: CLLocation){
        let center = location.coordinate
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let mapRegion = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(mapRegion, animated: true)
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        if overlay is MKPolyline {
            var polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.blueColor()
            polylineRenderer.lineWidth = 3
            centerViewOnLocation(CLLocation(latitude: overlay.coordinate.latitude, longitude: overlay.coordinate.longitude))
            return polylineRenderer
        } 
        return nil
    }
}
