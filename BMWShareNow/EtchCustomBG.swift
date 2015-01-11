//
//  EtchCustomBG.swift
//  Etch
//
//  Created by Jasper Sone on 12/31/14.
//  Copyright (c) 2014 Papafish. All rights reserved.
//

import UIKit

typealias EtchCustomBGType = String
// Transform
let EtchCustomBGTypeRoundedRect: EtchCustomBGType = "roundedRect"
let EtchCustomBGTypeCircle: EtchCustomBGType = "circle"


protocol EtchCustomBG {
    class func animateBackground<aView: UIView where aView: EtchCustomBGAnimation>(onView: aView, color: UIColor, completionHandler: (()->Void)!)
}

var gBGClasses = [EtchCustomBGType: EtchCustomBGBase.Type]()
let gEtchBGExceptionMethodsNotImplemented = "gEtchBGExceptionMethodsNotImplemented"
@objc class EtchCustomBGBase: NSObject, EtchCustomBG {
    
    var bgLayer: CAShapeLayer!
    
    override class func load() {
        
        println("In function \(__FUNCTION__) in \(self.description())")
        
        gBGClasses.removeAll(keepCapacity: true)
    }
    
    class func classForBGType(bgType: EtchCustomBGType) -> EtchCustomBGBase.Type! {
        
        println("In function \(__FUNCTION__) in \(self.description())")
        
        return gBGClasses[bgType]
    }
    
    class func registerClass(aClass: EtchCustomBGBase.Type, forBGType bgType: EtchCustomBGType) {
        
        println("In function \(__FUNCTION__) in \(self.description())")
        
        gBGClasses[bgType] = aClass
        println("Classes registered \(gBGClasses)")
    }
    class func animateBackground<aView: UIView where aView: EtchCustomBGAnimation>(onView: aView, color: UIColor, completionHandler: (()->Void)!) {
        
        println("In function \(__FUNCTION__) in \(self.description())")
        
        var error: NSError?
        NSException.raise(gEtchBGExceptionMethodsNotImplemented, format:"+[%@ updateBG] needed to be implemented", arguments:getVaList([error ?? "nil"]))
    }
}

@objc class EtchCustomBGRoundedRect: EtchCustomBGBase {
    
    override class func load() {
        
        println("In function \(__FUNCTION__) in \(self.description())")
        
        self.registerClass(self, forBGType: EtchCustomBGTypeRoundedRect)
    }
    
    override class func animateBackground<aView: UIView where aView: EtchCustomBGAnimation>(onView: aView, color: UIColor, completionHandler: (()->Void)!) {
        
        println("In function \(__FUNCTION__) in \(self.description())")
        
        println("BGLayer is \(onView)")
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            onView.bgLayer.path = UIBezierPath(roundedRect: onView.bgLayer.frame, cornerRadius: 38).CGPath
            completionHandler?()
        }
        onView.bgLayer.frame = onView.bounds
        onView.bgLayer.fillColor = color.CGColor
        onView.bgLayer.removeAnimationForKey(EtchCustomBGTypeRoundedRect)
        var pathAnimation = CABasicAnimation(keyPath: "path")
        pathAnimation.fillMode = kCAFillModeBoth
        pathAnimation.removedOnCompletion = false
        pathAnimation.fromValue = onView.bgLayer.path
        pathAnimation.toValue = UIBezierPath(roundedRect: onView.bgLayer.frame, cornerRadius: 38).CGPath
        onView.bgLayer.addAnimation(pathAnimation, forKey: EtchCustomBGTypeRoundedRect)
        CATransaction.commit()
    }
}

@objc class EtchCustomBGCircle: EtchCustomBGBase {
    
    override class func load() {
        
        println("In function \(__FUNCTION__) in \(self.description())")
        
        self.registerClass(self, forBGType: EtchCustomBGTypeCircle)
    }
    
    override class func animateBackground<aView: UIView where aView: EtchCustomBGAnimation>(onView: aView, color: UIColor, completionHandler: (()->Void)!) {
        
        println("In function \(__FUNCTION__) in \(self.description())")
        
        onView.bgLayer.frame = onView.layer.bounds
        onView.bgLayer.path = UIBezierPath(ovalInRect: onView.bounds).CGPath
        onView.bgLayer.fillColor = color.CGColor
        onView.bgLayer.setNeedsDisplay()
    }
}

