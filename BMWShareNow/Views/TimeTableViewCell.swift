//
//  TimeTableViewCell.swift
//  BMWShareNow
//
//  Created by Jasper Sone on 1/11/15.
//  Copyright (c) 2015 Papafish. All rights reserved.
//

import UIKit

class TimeTableViewCell: UITableViewCell {

    @IBOutlet weak var innerView: EtchCustomBGAnimationView!
    @IBOutlet weak var timeLeftView: UIView!
    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var minuteLabel: UILabel!
    
    var grayCircleLayer: CAShapeLayer!
    var blueCircleLayer: CAShapeLayer!
    var fromValue: Float!
    var toValue: Float!
    
    func setUpBackground() {
        
        println("In function \(__FUNCTION__) in \(self.description) \n")
        
        if self.grayCircleLayer == nil {
            self.setUpTimeView()
            
        }
    }
    
    func setUpTimeView() {
        
        println("In function \(__FUNCTION__) in \(self.description) \n")
        
        var path = UIBezierPath(ovalInRect: self.timeLeftView.bounds)
        let pattern: [CGFloat] = [2.0, 2.0]
        
        var grayShape = CAShapeLayer()
        grayShape.lineWidth = 8
        grayShape.lineDashPattern = pattern
        grayShape.strokeColor = gLightGrayColor.CGColor
        grayShape.path = path.CGPath
        grayShape.fillColor = UIColor.clearColor().CGColor
        self.grayCircleLayer = grayShape
        
        var blueShape = CAShapeLayer()
        self.blueCircleLayer = blueShape
        blueShape.lineWidth = 8
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
        strokeAnimation.fromValue = self.fromValue
        strokeAnimation.toValue = self.toValue
        blueShape.addAnimation(strokeAnimation, forKey: "Animate Stroke")
        CATransaction.commit()
        
        grayShape.addSublayer(blueShape)
        self.timeLeftView.layer.insertSublayer(grayShape, atIndex: 0)
    }
}
