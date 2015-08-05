//
//  GISUtils.swift
//  PBR
//
//  Created by Michael Hassin on 8/4/15.
//  Copyright (c) 2015 chihacknight. All rights reserved.
//

import UIKit
import MapKit

class GISUtils: NSObject {

    class func getPolyline(address1: String, address2: String) -> MKGeodesicPolyline {
        let url = NSURL(string: "https://chihack-pbr.herokuapp.com/polyline_for?origin=" + address1.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)! + "&destination=" + address2.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)
        let data = NSData(contentsOfURL: url!)
        var error: NSError?
        let waypoints = (NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: &error) as! NSArray) as! [Array<Double>]
        var locations = waypoints.map { CLLocationCoordinate2D(latitude: $0.first!, longitude: $0.last!) }
        let geodesic = MKGeodesicPolyline(coordinates: &locations[0], count: locations.count)
        return geodesic
    }
}
