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

    class func getPolyline(address1: String, address2: String){
        let originCoordinate = self.getCoordinate(address1)
        let destinationCoordinate = self.getCoordinate(address2)
        let url = NSURL(string: "")
    }
    
    class func getCoordinate(address: String) -> CLLocationCoordinate2D {
        println("hey")
        var error: NSError?
        let url = NSURL(string: "http://pelias.mapzen.com/search?input=" + address.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)
        let data = NSData(contentsOfURL: url!)
        let json = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: &error) as! NSDictionary
        let features = (json.objectForKey("features") as! NSArray) as Array
        let firstFeature = features.first as! NSDictionary
        let geometry = firstFeature.objectForKey("geometry") as! NSDictionary
        let coordinates = (geometry.objectForKey("coordinates") as! NSArray) as! [Double]
        let location = CLLocationCoordinate2D(latitude: coordinates.last!, longitude: coordinates.first!)
        println(location.latitude)
        println(location.longitude)
        return location
    }
}
