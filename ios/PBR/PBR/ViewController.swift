//
//  ViewController.swift
//  PBR
//
//  Created by Michael Hassin on 8/4/15.
//  Copyright (c) 2015 chihacknight. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(animated: Bool) {
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
            alert.dismissViewControllerAnimated(true, completion: nil)
            self.doRoute(originTextField!.text, destination: destinationTextField!.text)
        }))
        
        alert.addAction(UIAlertAction(title: "cancel", style: .Cancel, handler: { action in
            alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        presentViewController(alert, animated: true, completion: nil)
    }

    func doRoute(origin: String, destination: String){
        GISUtils.getCoordinate(origin)
        GISUtils.getCoordinate(destination)
    }
}

