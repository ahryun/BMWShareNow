//
//  CategoryTableViewCell.swift
//  BMWShareNow
//
//  Created by Jasper Sone on 1/10/15.
//  Copyright (c) 2015 Papafish. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var innerView: EtchCustomBGAnimationView!
    @IBOutlet weak var whiteCircle: UIView!
    @IBOutlet weak var categoryImageView: PFImageView!
    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    
    var whiteCircleLayer: CAShapeLayer!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }
    
    func setUpBackground(addCircle: Bool = true) {
        
        println("In function \(__FUNCTION__) in \(self.description) \n")
        
        if addCircle && self.whiteCircleLayer == nil {
            var whiteShape = CAShapeLayer()
            whiteShape.path = UIBezierPath(ovalInRect: self.whiteCircle.bounds).CGPath
            whiteShape.fillColor = UIColor.whiteColor().CGColor
            self.whiteCircleLayer = whiteShape
            self.whiteCircle.layer.addSublayer(whiteShape)
        } else if !addCircle && self.whiteCircleLayer != nil {
            self.whiteCircleLayer.removeFromSuperlayer()
        }
        
        var shape = CAShapeLayer()
        shape.path = UIBezierPath(ovalInRect: self.categoryImageView.bounds).CGPath
        self.categoryImageView.layer.mask = shape
        
        self.innerView.animate(delayed: false, completionHandler: nil)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }

}
