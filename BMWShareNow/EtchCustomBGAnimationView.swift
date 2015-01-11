//
//  EtchCustomBGAnimationView.swift
//  Etch
//
//  Created by Jasper Sone on 12/31/14.
//  Copyright (c) 2014 Papafish. All rights reserved.
//

import UIKit

protocol EtchCustomBGAnimation {
    var delay: NSNumber! { get }
    var duration: NSNumber! { get }
    var type: CSAnimationType! { get }
    var pauseAnimationOnAwake: Bool! { get }
    var bgType: EtchCustomBGType! { get }
    var color: UIColor!{ get }
    var bgLayer: CAShapeLayer! { get set }
    func animateOnAwake()
    func animatePosition(#delayed: Bool, completionHandler: (()->Void)!)
    func animateBackground(#completionHandler: (()->Void)!)
    func animate(#delayed: Bool, completionHandler: (()->Void)!)
}

extension UIView {
    public func animatePosition(#delayed: Bool, completionHandler: (()->Void)!) {
        
        println("In function \(__FUNCTION__) in \(self.description)")
        
        for view in self.subviews as [UIView] {
            view.animatePosition(delayed: delayed, completionHandler: completionHandler)
        }
    }
    
    public func animateBackground(#completionHandler: (()->Void)!) {
        
        println("In function \(__FUNCTION__) in \(self.description)")
        
        for view in self.subviews as [UIView] {
            view.animateBackground(completionHandler: completionHandler)
        }
    }
    
    public func animate(#delayed: Bool, completionHandler: (()->Void)!) {
        
        println("In function \(__FUNCTION__) in \(self.description)")
        
        for view in self.subviews as [UIView] {
            view.animate(delayed: delayed, completionHandler: completionHandler)
        }
    }
}

public class EtchCustomBGAnimationView: UIView, EtchCustomBGAnimation {
    
    var delay: NSNumber!
    var duration: NSNumber!
    var type: CSAnimationType!
    var pauseAnimationOnAwake: Bool!
    var bgType: EtchCustomBGType!
    var color: UIColor!
    var bgLayer: CAShapeLayer!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        println("In function \(__FUNCTION__) in \(self.description)")
        
        self.animateOnAwake()
    }
    
    public override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
        if key == "pauseAnimationOnAwake" {
            self.pauseAnimationOnAwake = value?.boolValue
        }
    }
    
    func animateOnAwake() {
        
        println("In function \(__FUNCTION__) in \(self.description)")
        
        self.clipsToBounds = false
        
        // Animation
        if self.type != nil && self.duration != nil {
            if self.pauseAnimationOnAwake == nil || (self.pauseAnimationOnAwake != nil && !self.pauseAnimationOnAwake) {
                self.animatePosition(delayed: true, completionHandler: nil)
            }
        }
        
        // Custom BG
        if self.bgType != nil && self.color != nil {
            self.bgLayer = CAShapeLayer()
            self.layer.insertSublayer(self.bgLayer, atIndex: 0)
        }
    }
    
    // Manually calling animation
    public override func animatePosition(#delayed: Bool, completionHandler: (()->Void)!) {
        
        println("In function \(__FUNCTION__) in \(self.description)")
        
        // Animation
        if self.type != nil && self.duration != nil {
            if let aClass = CSAnimation.classForAnimationType(self.type) as? CSAnimation.Type {
                aClass.performAnimationOnView(self, duration: self.duration.doubleValue, delay: (self.delay != nil ? self.delay.doubleValue : 0), completionHandler: completionHandler)
                super.animatePosition(delayed: delayed, completionHandler: nil)
            }
        }
    }
    
    // Manually calling updating BG
    public override func animateBackground(#completionHandler: (()->Void)!) {
        
        println("In function \(__FUNCTION__) in \(self.description)")
        
        // Custom BG
        if self.bgType != nil && self.color != nil {
            var EtchBGClass = EtchCustomBGBase.classForBGType(self.bgType)
            EtchBGClass.animateBackground(self, color: self.color, completionHandler: completionHandler)
            super.animateBackground(completionHandler: nil)
        }
    }
    
    public override func animate(#delayed: Bool, completionHandler: (()->Void)!) {
        
        println("In function \(__FUNCTION__) in \(self.description)")
        
        var backgroundDone: Bool = false, positionDone: Bool = false
        self.animateBackground(completionHandler: {
            backgroundDone = true
            if positionDone { completionHandler?() }
        })
        self.animatePosition(delayed: delayed, completionHandler: {
            positionDone = true
            if backgroundDone { completionHandler?() }
        })
    }
}

public class EtchCustomBGAnimationTextView: UITextView, EtchCustomBGAnimation {
    
    var delay: NSNumber!
    var duration: NSNumber!
    var type: CSAnimationType!
    var pauseAnimationOnAwake: Bool!
    var bgType: EtchCustomBGType!
    var color: UIColor!
    var bgLayer: CAShapeLayer!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        println("In function \(__FUNCTION__) in \(self.description)")
        
        self.animateOnAwake()
    }
    
    public override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
        if key == "pauseAnimationOnAwake" {
            self.pauseAnimationOnAwake = value?.boolValue
        }
    }
    
    func animateOnAwake() {
        
        println("In function \(__FUNCTION__) in \(self.description)")
        
        self.clipsToBounds = false
        
        // Custom BG
        if self.bgType != nil && self.color != nil {
            self.bgLayer = CAShapeLayer()
            self.layer.insertSublayer(self.bgLayer, atIndex: 0)
        }
        
        // Animation
        if self.type != nil && self.duration != nil {
            if self.pauseAnimationOnAwake == nil || (self.pauseAnimationOnAwake != nil && !self.pauseAnimationOnAwake) {
                self.animatePosition(delayed: true, completionHandler: nil)
            }
        }
    }
    
    // Manually calling animation
    public override func animatePosition(#delayed: Bool, completionHandler: (()->Void)!) {
        
        println("In function \(__FUNCTION__) in \(self.description)")
        
        // Animation
        if self.type != nil && self.duration != nil {
            if let aClass = CSAnimation.classForAnimationType(self.type) as? CSAnimation.Type {
                aClass.performAnimationOnView(self, duration: self.duration.doubleValue, delay: (self.delay != nil ? self.delay.doubleValue : 0), completionHandler: completionHandler)
                super.animatePosition(delayed: delayed, completionHandler: nil)
            }
        }
    }
    
    // Manually calling updating BG
    public override func animateBackground(#completionHandler: (()->Void)!) {
        
        println("In function \(__FUNCTION__) in \(self.description)")
        
        // Custom BG
        if self.bgType != nil && self.color != nil {
            var EtchBGClass = EtchCustomBGBase.classForBGType(self.bgType)
            EtchBGClass.animateBackground(self, color: self.color, completionHandler: completionHandler)
            super.animateBackground(completionHandler: nil)
        }
    }
    
    public override func animate(#delayed: Bool, completionHandler: (()->Void)!) {
        
        println("In function \(__FUNCTION__) in \(self.description)")
        
        var backgroundDone: Bool = false, positionDone: Bool = false
        self.animateBackground(completionHandler: {
            backgroundDone = true
            if positionDone { completionHandler?() }
        })
        self.animatePosition(delayed: delayed, completionHandler: {
            positionDone = true
            if backgroundDone { completionHandler?() }
        })
    }
}

public class EtchCustomBGAnimationTextField: UITextField, EtchCustomBGAnimation {
    
    var delay: NSNumber!
    var duration: NSNumber!
    var type: CSAnimationType!
    var pauseAnimationOnAwake: Bool!
    var bgType: EtchCustomBGType!
    var color: UIColor!
    var bgLayer: CAShapeLayer!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        println("In function \(__FUNCTION__) in \(self.description)")
        
        self.animateOnAwake()
    }
    
    public override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
        if key == "pauseAnimationOnAwake" {
            self.pauseAnimationOnAwake = value?.boolValue
        }
    }
    
    func animateOnAwake() {
        
        println("In function \(__FUNCTION__) in \(self.description)")
        
        self.clipsToBounds = false
        
        // Custom BG
        if self.bgType != nil && self.color != nil {
            self.bgLayer = CAShapeLayer()
            self.layer.insertSublayer(self.bgLayer, atIndex: 0)
        }
        
        // Animation
        if self.type != nil && self.duration != nil {
            if self.pauseAnimationOnAwake == nil || (self.pauseAnimationOnAwake != nil && !self.pauseAnimationOnAwake) {
                self.animatePosition(delayed: true, completionHandler: nil)
            }
        }
    }
    
    // Manually calling animation
    public override func animatePosition(#delayed: Bool, completionHandler: (()->Void)!) {
        
        println("In function \(__FUNCTION__) in \(self.description)")
        
        // Animation
        if self.type != nil && self.duration != nil {
            if let aClass = CSAnimation.classForAnimationType(self.type) as? CSAnimation.Type {
                aClass.performAnimationOnView(self, duration: self.duration.doubleValue, delay: (self.delay != nil ? self.delay.doubleValue : 0), completionHandler: completionHandler)
                super.animatePosition(delayed: delayed, completionHandler: nil)
            }
        }
    }
    
    // Manually calling updating BG
    public override func animateBackground(#completionHandler: (()->Void)!) {
        
        println("In function \(__FUNCTION__) in \(self.description)")
        
        // Custom BG
        if self.bgType != nil && self.color != nil {
            var EtchBGClass = EtchCustomBGBase.classForBGType(self.bgType)
            EtchBGClass.animateBackground(self, color: self.color, completionHandler: completionHandler)
            super.animateBackground(completionHandler: nil)
        }
    }
    
    public override func animate(#delayed: Bool, completionHandler: (()->Void)!) {
        
        println("In function \(__FUNCTION__) in \(self.description)")
        
        var backgroundDone: Bool = false, positionDone: Bool = false
        self.animateBackground(completionHandler: {
            backgroundDone = true
            if positionDone { completionHandler?() }
        })
        self.animatePosition(delayed: delayed, completionHandler: {
            positionDone = true
            if backgroundDone { completionHandler?() }
        })
    }
}

public class EtchCustomBGAnimationLabel: UILabel, EtchCustomBGAnimation {
    
    var delay: NSNumber!
    var duration: NSNumber!
    var type: CSAnimationType!
    var pauseAnimationOnAwake: Bool!
    var bgType: EtchCustomBGType!
    var color: UIColor!
    var bgLayer: CAShapeLayer!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        println("In function \(__FUNCTION__) in \(self.description)")
        
        self.animateOnAwake()
    }
    
    public override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
        if key == "pauseAnimationOnAwake" {
            self.pauseAnimationOnAwake = value?.boolValue
        }
    }
    
    func animateOnAwake() {
        
        println("In function \(__FUNCTION__) in \(self.description)")
        
        self.clipsToBounds = false
        
        // Custom BG
        if self.bgType != nil && self.color != nil {
            self.bgLayer = CAShapeLayer()
            self.layer.insertSublayer(self.bgLayer, atIndex: 0)
        }
        
        // Animation
        if self.type != nil && self.duration != nil {
            if self.pauseAnimationOnAwake == nil || (self.pauseAnimationOnAwake != nil && !self.pauseAnimationOnAwake) {
                self.animatePosition(delayed: true, completionHandler: nil)
            }
        }
    }
    
    // Manually calling animation
    public override func animatePosition(#delayed: Bool, completionHandler: (()->Void)!) {
        
        println("In function \(__FUNCTION__) in \(self.description)")
        
        // Animation
        if self.type != nil && self.duration != nil {
            if let aClass = CSAnimation.classForAnimationType(self.type) as? CSAnimation.Type {
                aClass.performAnimationOnView(self, duration: self.duration.doubleValue, delay: (self.delay != nil ? self.delay.doubleValue : 0), completionHandler: completionHandler)
                super.animatePosition(delayed: delayed, completionHandler: nil)
            }
        }
    }
    
    // Manually calling updating BG
    public override func animateBackground(#completionHandler: (()->Void)!) {
        
        println("In function \(__FUNCTION__) in \(self.description)")
        
        // Custom BG
        if self.bgType != nil && self.color != nil {
            var EtchBGClass = EtchCustomBGBase.classForBGType(self.bgType)
            EtchBGClass.animateBackground(self, color: self.color, completionHandler: completionHandler)
            super.animateBackground(completionHandler: nil)
        }
    }
    
    public override func animate(#delayed: Bool, completionHandler: (()->Void)!) {
        
        println("In function \(__FUNCTION__) in \(self.description)")
        
        var backgroundDone: Bool = false, positionDone: Bool = false
        self.animateBackground(completionHandler: {
            backgroundDone = true
            if positionDone { completionHandler?() }
        })
        self.animatePosition(delayed: delayed, completionHandler: {
            positionDone = true
            if backgroundDone { completionHandler?() }
        })
    }
}

public class EtchCustomBGAnimationButton: UIButton, EtchCustomBGAnimation {
    
    var delay: NSNumber!
    var duration: NSNumber!
    var type: CSAnimationType!
    var pauseAnimationOnAwake: Bool!
    var bgType: EtchCustomBGType!
    var color: UIColor!
    var bgLayer: CAShapeLayer!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        println("In function \(__FUNCTION__) in \(self.description)")
        
        self.animateOnAwake()
    }
    
    public override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
        if key == "pauseAnimationOnAwake" {
            self.pauseAnimationOnAwake = value?.boolValue
        }
    }
    
    func animateOnAwake() {
        
        println("In function \(__FUNCTION__) in \(self.description)")
        
        self.clipsToBounds = false
        
        // Custom BG
        if self.bgType != nil && self.color != nil {
            self.bgLayer = CAShapeLayer()
            self.layer.insertSublayer(self.bgLayer, atIndex: 0)
        }
        
        // Animation
        if self.type != nil && self.duration != nil {
            if self.pauseAnimationOnAwake == nil || (self.pauseAnimationOnAwake != nil && !self.pauseAnimationOnAwake) {
                self.animatePosition(delayed: true, completionHandler: nil)
            }
        }
    }
    
    // Manually calling animation
    public override func animatePosition(#delayed: Bool, completionHandler: (()->Void)!) {
        
        println("In function \(__FUNCTION__) in \(self.description)")
        
        // Animation
        if self.type != nil && self.duration != nil {
            if let aClass = CSAnimation.classForAnimationType(self.type) as? CSAnimation.Type {
                aClass.performAnimationOnView(self, duration: self.duration.doubleValue, delay: (self.delay != nil ? self.delay.doubleValue : 0), completionHandler: completionHandler)
                super.animatePosition(delayed: delayed, completionHandler: nil)
            }
        }
    }
    
    // Manually calling updating BG
    public override func animateBackground(#completionHandler: (()->Void)!) {
        
        println("In function \(__FUNCTION__) in \(self.description)")
        
        // Custom BG
        if self.bgType != nil && self.color != nil {
            var EtchBGClass = EtchCustomBGBase.classForBGType(self.bgType)
            EtchBGClass.animateBackground(self, color: self.color, completionHandler: completionHandler)
            super.animateBackground(completionHandler: nil)
        }
    }
    
    public override func animate(#delayed: Bool, completionHandler: (()->Void)!) {
        
        println("In function \(__FUNCTION__) in \(self.description)")
        
        var backgroundDone: Bool = false, positionDone: Bool = false
        self.animateBackground(completionHandler: {
            backgroundDone = true
            if positionDone { completionHandler?() }
        })
        self.animatePosition(delayed: delayed, completionHandler: {
            positionDone = true
            if backgroundDone { completionHandler?() }
        })
    }
}



