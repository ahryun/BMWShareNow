//
//  FriendsRequestAlertView.swift
//  WhereUAt
//
//  Created by Jasper Sone on 12/1/14.
//  Copyright (c) 2014 Ahryun Moon. All rights reserved.
//

import UIKit

class FriendsRequestAlertView: UIView {
    
    var friend: PFUser!
    var photoImageView: PFImageView!
    var nameLabel: UILabel!
    
    required init(coder aDecoder: NSCoder) {
        
        println("In function \(__FUNCTION__)")
        
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        
        println("In function \(__FUNCTION__)")
        
        super.init(frame: frame)
    }
    
    convenience init(friend: PFUser) {
        
        let rect = CGRect(x: 0, y: 0, width: 260, height: 130)
        self.init(frame: rect)
        self.friend = friend
        
        self.clipsToBounds = false
        self.backgroundColor = UIColor.clearColor()
        let diameter:CGFloat = 100.0
        var originX = CGFloat(rect.width / 2.0) - (diameter / 2.0)
        var grayCircle = UIImageView(frame: CGRect(x: originX, y: -diameter / 2.0, width: diameter, height: diameter))
        grayCircle.image = UIImage(named: "grayCircle_large")
        var photoImageView = PFImageView(frame: CGRectInset(grayCircle.bounds, 8.0, 8.0))
        if let thumbnailPhoto = friend["thumbnail"] as? PFFile {
            photoImageView.file = thumbnailPhoto
            photoImageView.loadInBackground(nil)
        }
        photoImageView.contentMode = .ScaleAspectFill
        photoImageView.maskInCircle()
        grayCircle.addSubview(photoImageView)
        self.photoImageView = photoImageView
        self.addSubview(grayCircle)
        
        var nameLabel = UILabel(frame: CGRect(x: 10.0, y: (diameter / 2.0) + 10.0, width: rect.width - (10.0 * 2), height: 30.0))
        nameLabel.textAlignment = NSTextAlignment.Center
        nameLabel.font = gMediumFont
        nameLabel.textColor = gDarkGrayColor
        var fullName = friend["name"] as? String

        nameLabel.text = fullName
        self.nameLabel = nameLabel
        self.addSubview(nameLabel)
        
        var questionLabel = UILabel(frame: CGRect(x: 10.0, y: (diameter / 2.0) + 40.0, width: rect.width - (10.0 * 2), height: 20.0))
        questionLabel.text = "requested a ride!"
        questionLabel.textAlignment = NSTextAlignment.Center
        questionLabel.font = gSmallFont
        questionLabel.textColor = gLighterGrayColor
        self.addSubview(questionLabel)
    }
}
