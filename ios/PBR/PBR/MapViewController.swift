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
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Route", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("displayRoutingModal"))
        mapView = MKMapView(frame: self.view.frame)
        mapView.delegate = self
//        mapView.showsUserLocation = true
        self.view.addSubview(mapView)
    }
    
    override func viewDidAppear(animated: Bool) {
        displayRoutingModal()
    }
    
    func displayRoutingModal() {
        var originTextField: UITextField?
        var destinationTextField: UITextField?
        let alert = UIAlertController(title: "Route me", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addTextFieldWithConfigurationHandler { (textField) -> Void in
            originTextField = textField
            // TODO: delete
            originTextField!.text = "navy pier chicago"
        }
        
        alert.addTextFieldWithConfigurationHandler { (textField) -> Void in
            destinationTextField = textField
            // TODO: delete
            destinationTextField!.text = "merchandise mart chicago"
        }
        
        alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.Default, handler: { action in
            self.doRoute(originTextField!.text, destination: destinationTextField!.text)
        }))
        
        alert.addAction(UIAlertAction(title: "cancel", style: .Cancel, handler: { action in
            alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func centerViewOnLocation(location: CLLocation){
        let center = location.coordinate
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let mapRegion = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(mapRegion, animated: true)
    }
    
    func doRoute(origin: String, destination: String){
        mapView.removeOverlays(mapView.overlays)
        mapView.addOverlay(GISUtils.getPolyline(origin, address2: destination))
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
