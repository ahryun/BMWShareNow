//
//  LoginViewController.swift
//  BMWShareNow
//
//  Created by Jasper Sone on 1/10/15.
//  Copyright (c) 2015 Papafish. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginViaFacebook(sender: AnyObject) {
        
        println("In function \(__FUNCTION__) in \(self.description) \n")
        
        if PFUser.currentUser() == nil {
            PFFacebookUtils.logInWithPermissions(["email", "public_profile", "user_friends"], {
                (user: PFUser!, error: NSError!) -> Void in
                if user != nil {
                    println("User logged in through Facebook!")
                    
                }
            })
        }
        self.performSegueWithIdentifier("To Main Controller", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        println("In function \(__FUNCTION__) in \(self.description) \n")
        
        if segue.identifier == "To Main Controller" {
            self.navigationController?.navigationBarHidden = false
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
