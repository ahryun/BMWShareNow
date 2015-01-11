//
//  StringExt.swift
//  WhereUAt
//
//  Created by Jasper Sone on 6/24/14.
//  Copyright (c) 2014 Ahryun Moon. All rights reserved.
//

import Foundation
import QuartzCore
import CoreImage
import UIKit

extension String {
    subscript (i: Int) -> String? {
        return String(Array(self)[i])
    }
    
    func formatUSPhoneNumber() -> String? {
        // User unformatUSPhoneNumber function first
        // This function assumes that String is in dddddddddd format
        var numberOnlyString = self as NSString
        if countElements(self) >= 10 {
            var formattedNumber = "(\(numberOnlyString.substringToIndex(3))) \(numberOnlyString.substringWithRange(NSRange(location: 3,length: 3)))-\(numberOnlyString.substringWithRange(NSRange(location: 6,length: 4)))"
            return formattedNumber
        }
        return numberOnlyString
    }
    
    func unformatUSPhoneNumber() -> String? {
        var numberOnlyString = "".join(self.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet)) as NSString
        var unformattedNumber: String?
        if numberOnlyString.length == 11 && numberOnlyString.substringToIndex(1) == "1" {
            numberOnlyString = numberOnlyString.substringWithRange(NSRange(location: 1,length: 10))
        }
        if numberOnlyString.length == 10 {
            unformattedNumber = numberOnlyString
        }
        
        return unformattedNumber
    }
}

extension Double {
    func format(f: String) -> String {
        return NSString(format: "%\(f)f", self)
    }
}

extension UIButton {
    func enableSelf() {
        self.alpha = 1.0
        self.enabled = true
    }
    
    func disableSelf() {
        self.alpha = 0.2
        self.enabled = false
    }
}

extension UIImageView {
    func maskInCircle() {
        let circle: UIBezierPath = UIBezierPath(ovalInRect: self.bounds)
        var shapeLayer: CAShapeLayer = CAShapeLayer()
        shapeLayer.path = circle.CGPath
        shapeLayer.frame = self.bounds;
        self.layer.mask = shapeLayer;
    }
}

extension Array {
    var last: T {
    return self[self.endIndex - 1]
    }
    var first: T {
    return self[0]
    }
}

let gPulsingAnimationKey        = "pulsingAnimation"
extension UIView {
    func pulse() {
        self.layer.removeAnimationForKey(gPulsingAnimationKey)
        var pulsingAnimation: CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
        pulsingAnimation.fromValue = NSNumber(float: 1.0)
        pulsingAnimation.toValue = NSNumber(float: 1.2)
        
        var alphaAnimation: CABasicAnimation = CABasicAnimation(keyPath: "opacity")
        alphaAnimation.fromValue = NSNumber(float: 0.5)
        alphaAnimation.toValue = NSNumber(float: 0)
        
        var group: CAAnimationGroup = CAAnimationGroup()
        group.duration = 2.0
        group.repeatCount = Float.infinity
        group.removedOnCompletion = false
        group.animations = [pulsingAnimation, alphaAnimation]
        
        self.layer.addAnimation(group, forKey: gPulsingAnimationKey)
    }
}
