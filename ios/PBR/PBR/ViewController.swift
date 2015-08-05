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
        var usernameTextField: UITextField?
        var passwordTextField: UITextField?
        let alert = UIAlertController(title: "Log in", message: "enter your username and password to continue", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addTextFieldWithConfigurationHandler { (textField) -> Void in
            usernameTextField = textField
        }
        
        alert.addTextFieldWithConfigurationHandler { (textField) -> Void in
            passwordTextField = textField
        }
        
        alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.Default, handler: { action in
            alert.dismissViewControllerAnimated(true, completion: nil)
            self.doRoute(usernameTextField!.text, password: passwordTextField!.text)
        }))
        
        alert.addAction(UIAlertAction(title: "cancel", style: .Cancel, handler: { action in
            alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        presentViewController(alert, animated: true, completion: nil)
    }

    func doRoute(origin: String, destination: String){
        
    }

}

