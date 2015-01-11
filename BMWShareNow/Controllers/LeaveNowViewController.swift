//
//  LeaveNowViewController.swift
//  BMWShareNow
//
//  Created by Jasper Sone on 1/11/15.
//  Copyright (c) 2015 Papafish. All rights reserved.
//

import UIKit

class LeaveNowViewController: UIViewController {
    
    @IBOutlet weak var minutesLeftView: EtchCustomBGAnimationView!
    @IBOutlet weak var leaveNowButton: UIButton!
    @IBOutlet weak var minsLabel: UILabel!
    @IBOutlet weak var minuteLabel: UILabel!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var subLabel: UILabel!
    @IBOutlet weak var noPassengerLabel: UILabel!
    @IBOutlet weak var passengerImage: PFImageView!
    
    var selectedMinute: [String:String]!
    var numberSelected: Int!
    var locationSelected: String!
    var queryName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if self.selectedMinute["minutes"] != "L" {
            self.minuteLabel.text = self.selectedMinute["minutes"]
        } else {
            self.minuteLabel.text = "Later"
            self.minsLabel.hidden = true
            self.mainLabel.text = "depart"
        }
        
        self.mainLabel.text = self.queryName
        self.subLabel.text = self.locationSelected
        
        self.setUpButton()
        self.sendPushNotification()
        self.postToFacebook()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        println("In function \(__FUNCTION__) in \(self.description) \n")
        
        self.setUpMinutesLeftView()
        self.showPopUp()
        self.registerForNotifications()
        self.noPassengerLabel.pulse()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        println("In function \(__FUNCTION__) in \(self.description) \n")
        
        self.unregisterForNotifications()
    }
    
    func registerForNotifications() {
        
        println("In function \(__FUNCTION__)")
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("showPassengerAdded:"), name: "RideRequest", object: nil)
    }
    
    func unregisterForNotifications() {
        
        println("In function \(__FUNCTION__)")
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "RideRequest", object: nil)
    }

    @IBAction func backButtonPressed(sender: AnyObject) {
        
        println("In function \(__FUNCTION__) in \(self.description) \n")
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func postToFacebook() {
        
        println("In function \(__FUNCTION__) in \(self.description) \n")
        
        // Post to facebook
    }
    
    func sendPushNotification() {
        
        println("In function \(__FUNCTION__) in \(self.description) \n")
        
        var userQuery = PFUser.query()
        userQuery.getObjectWithId("ABwVQVEsvk")
        
        var pushQuery = PFInstallation.query()
        pushQuery.whereKey("user", matchesQuery: userQuery)
        
        var push = PFPush()
        push.setQuery(pushQuery)
        push.setMessage("I'm going to \(self.locationSelected). Want a ride?")
        push.sendPushInBackgroundWithBlock(nil)
    }
    
    func setUpMinutesLeftView() {
        
        println("In function \(__FUNCTION__) in \(self.description) \n")
        
        var path = UIBezierPath(ovalInRect: self.minutesLeftView.bounds)
        let pattern: [CGFloat] = [2.0, 2.0]
        
        var grayShape = CAShapeLayer()
        
        grayShape.lineWidth = 16
        grayShape.lineDashPattern = pattern
        grayShape.strokeColor = gLightGrayColor.CGColor
        grayShape.path = path.CGPath
        grayShape.fillColor = UIColor.clearColor().CGColor
        
        var blueShape = CAShapeLayer()
        blueShape.lineWidth = 16
        blueShape.lineDashPattern = pattern
        blueShape.strokeColor = gBlueColor.CGColor
        blueShape.path = path.CGPath
        blueShape.fillColor = UIColor.clearColor().CGColor
        
        CATransaction.begin()
        blueShape.removeAnimationForKey("Animate Stroke")
        var strokeAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeAnimation.fillMode = kCAFillModeBoth
        strokeAnimation.removedOnCompletion = false
        strokeAnimation.duration = 0.5
        strokeAnimation.fromValue = 0
        strokeAnimation.toValue = Float(self.numberSelected) / 4
        blueShape.addAnimation(strokeAnimation, forKey: "Animate Stroke")
        CATransaction.commit()
        
        grayShape.addSublayer(blueShape)
        self.minutesLeftView.layer.insertSublayer(grayShape, atIndex: 0)
    }
    
    func setUpButton() {
        
        println("In function \(__FUNCTION__) in \(self.description) \n")
        
        self.leaveNowButton.addTarget(self, action: Selector("leaveNowButtonPressed:"), forControlEvents: UIControlEvents.TouchUpInside)
        var shape = CAShapeLayer()
        shape.path = UIBezierPath(roundedRect: self.leaveNowButton.bounds, cornerRadius: self.leaveNowButton.frame.height / 2).CGPath
        shape.lineWidth = 4.0
        shape.strokeColor = UIColor.whiteColor().CGColor
        shape.fillColor = UIColor.clearColor().CGColor
        self.leaveNowButton.layer.addSublayer(shape)
        self.leaveNowButton.setTitle("Leave Now", forState: .Normal)
        self.leaveNowButton.titleLabel?.font = gMediumFont
        self.leaveNowButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    }
    
    func leaveNowButtonPressed(sender: AnyObject!) {
        
        println("In function \(__FUNCTION__) in \(self.description) \n")
        
        PFCloud.callFunctionInBackground("startTrip", withParameters: ["rideID": "zyfKT7Hq95"], block: nil)
        let alertView: UIAlertView = UIAlertView(title: "Perfect!", message: "Navigation information has been sent to your vehicle", delegate: self, cancelButtonTitle: "OK")
        alertView.show()
    }
    
    func showPopUp() {
        let alertView: UIAlertView = UIAlertView(title: "Awesome!", message: "Your trip has been posted to Facebook. Nearby friends will be notified. Wait for passengers.", delegate: nil, cancelButtonTitle: "OK")
        alertView.show()
    }
    
    func showPassengerAdded(sender: AnyObject!) {
        
        var query = PFUser.query()
        query.whereKey("username", equalTo: "peter")
        query.getFirstObjectInBackgroundWithBlock() {
            (friend, err) in
            if err == nil {
                var alertView = CustomIOS7AlertView()
                alertView.containerView = FriendsRequestAlertView(friend: friend as PFUser)
                alertView.buttonTitles = ["OK"]
                alertView.onButtonTouchUpInside = {
                    (alertView: CustomIOS7AlertView!, buttonIndex: Int32) -> Void in
                    if buttonIndex == 1 {
                        // Accept
                    }
                    alertView.close()
                    // Make peter's face popup
                    self.noPassengerLabel.hidden = true
                    self.passengerImage.file = (friend as PFUser)["thumbnail"] as PFFile
                    self.passengerImage.loadInBackground() {
                        (success) in
                        var maskLayer = CAShapeLayer()
                        maskLayer.path = UIBezierPath(ovalInRect: self.passengerImage.bounds).CGPath
                        self.passengerImage.layer.mask = maskLayer
                        var pathAnimation = CABasicAnimation(keyPath: "path")
                        pathAnimation.fillMode = kCAFillModeBoth
                        pathAnimation.removedOnCompletion = false
                        pathAnimation.duration = 0.5
                        pathAnimation.fromValue = UIBezierPath(ovalInRect: CGRect(x: self.passengerImage.frame.width / 2 - 2.0, y: self.passengerImage.frame.height / 2 - 2.0, width: 4.0, height: 4.0)).CGPath
                        pathAnimation.toValue = UIBezierPath(ovalInRect: self.passengerImage.bounds).CGPath
                        self.passengerImage.layer.mask.addAnimation(pathAnimation, forKey: "PathAnimation")
                    }
                }
                alertView.show()
            }
        }
    }
}

extension LeaveNowViewController: UIAlertViewDelegate {
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        self.performSegueWithIdentifier("Map View", sender: self)
    }
}
