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
        }
        
        self.mainLabel.text = self.queryName
        self.subLabel.text = self.locationSelected
        
        self.setUpButton()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        println("In function \(__FUNCTION__) in \(self.description) \n")
        
        self.setUpMinutesLeftView()
    }

    @IBAction func backButtonPressed(sender: AnyObject) {
        
        println("In function \(__FUNCTION__) in \(self.description) \n")
        
        self.navigationController?.popViewControllerAnimated(true)
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
        self.leaveNowButton.setTitle("Share Ride", forState: .Normal)
        self.leaveNowButton.titleLabel?.font = gMediumFont
        self.leaveNowButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    }
    
    func leaveNowButtonPressed(sender: AnyObject!) {
        
        println("In function \(__FUNCTION__) in \(self.description) \n")
        
        
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
