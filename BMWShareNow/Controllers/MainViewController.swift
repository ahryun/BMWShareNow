//
//  MainViewController.swift
//  BMWShareNow
//
//  Created by Jasper Sone on 1/10/15.
//  Copyright (c) 2015 Papafish. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var categoryCollection: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var creditView: EtchCustomBGAnimationView!
    @IBOutlet weak var batteryChargingView: UIView!
    @IBOutlet weak var friend1ImageView: PFImageView!
    @IBOutlet weak var friend2ImageView: PFImageView!
    @IBOutlet weak var friend3ImageView: PFImageView!
    @IBOutlet weak var friend4ImageView: PFImageView!
    @IBOutlet weak var subLabel: UILabel!
    
    var blueShape: CAShapeLayer!
    var grayShape: CAShapeLayer!
    var toValue: Float = 0.5
    var queryName: String!
    
    var categories = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUp()
        self.queryCategories()
    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        
        self.view.animate(delayed: true, completionHandler: {
            self.setUpCreditView(self.toValue)
            self.setUpButton()
            self.setUpFriends()
        })
    }
    
    @IBAction func unwindToMain(segue: UIStoryboardSegue) {
        // update the button
        self.subLabel.text = "1 more trip to top off to full"
        self.toValue = 0.75
    }
    
    func setUp() {
        
        println("In function \(__FUNCTION__) in \(self.description) \n")
        
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController?.navigationBar.barTintColor = gDarkGrayColor
        self.navigationItem.hidesBackButton = true
        
        self.categoryCollection.backgroundColor = UIColor.clearColor()
        
        self.pageControl.pageIndicatorTintColor = gLighterGrayColor
        self.pageControl.currentPageIndicatorTintColor = gBlueColor
    }
    
    func setUpFriends() {
        
        println("In function \(__FUNCTION__) in \(self.description) \n")
        
        var query = PFUser.query()
        var usernameArray = ["seth", "amy", "jasper", "peter"]
        query.cachePolicy = kPFCachePolicyCacheElseNetwork
        query.whereKey("username", containedIn: usernameArray)
        query.findObjectsInBackgroundWithBlock() {
            (users, err) in
            if err == nil && users.count == usernameArray.count {
                var imageViewArray = [self.friend1ImageView, self.friend2ImageView, self.friend3ImageView, self.friend4ImageView]
                for i in 0..<imageViewArray.count {
                    imageViewArray[i].file = (users[i] as PFUser)["thumbnail"] as PFFile
                    imageViewArray[i].loadInBackground() {
                        (success) in
                        var maskLayer = CAShapeLayer()
                        maskLayer.path = UIBezierPath(ovalInRect: imageViewArray[i].bounds).CGPath
                        imageViewArray[i].layer.mask = maskLayer
                        var pathAnimation = CABasicAnimation(keyPath: "path")
                        pathAnimation.fillMode = kCAFillModeBoth
                        pathAnimation.removedOnCompletion = false
                        pathAnimation.duration = 0.5
                        pathAnimation.fromValue = UIBezierPath(ovalInRect: CGRect(x: imageViewArray[i].frame.width / 2 - 2.0, y: imageViewArray[i].frame.height / 2 - 2.0, width: 4.0, height: 4.0)).CGPath
                        pathAnimation.toValue = UIBezierPath(ovalInRect: imageViewArray[i].bounds).CGPath
                        imageViewArray[i].layer.mask.addAnimation(pathAnimation, forKey: "PathAnimation")
                    }
                }
            }
        }
    }
    
    func setUpButton() {
        
        println("In function \(__FUNCTION__) in \(self.description) \n")
        
        let buttonHeight: CGFloat = 60
        var button = UIButton(frame: CGRect(x: 20, y: self.view.frame.height - buttonHeight - 20, width: self.view.frame.width - 40, height: buttonHeight))
        button.addTarget(self, action: Selector("shareRideButtonPressed:"), forControlEvents: UIControlEvents.TouchUpInside)
        var shape = CAShapeLayer()
        shape.path = UIBezierPath(roundedRect: button.bounds, cornerRadius: button.frame.height / 2).CGPath
        shape.lineWidth = 4.0
        shape.strokeColor = UIColor.whiteColor().CGColor
        shape.fillColor = UIColor.clearColor().CGColor
        button.layer.addSublayer(shape)
        button.setTitle("Share Ride", forState: .Normal)
        button.titleLabel?.font = gMediumFont
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.view.addSubview(button)
    }
    
    func setUpCreditView(toValue: Float) {
        
        println("In function \(__FUNCTION__) in \(self.description) \n")
        
        var path = UIBezierPath(ovalInRect: self.batteryChargingView.bounds)
        let pattern: [CGFloat] = [2.0, 2.0]
        
        if self.blueShape != nil {
            self.blueShape.removeAllAnimations()
            self.blueShape.removeFromSuperlayer()
            self.blueShape = nil
        }
        
        if self.grayShape != nil {
            self.grayShape.removeAllAnimations()
            self.grayShape.removeFromSuperlayer()
            self.grayShape = nil
        }
        
        self.grayShape = CAShapeLayer()
        self.grayShape.lineWidth = 8
        self.grayShape.lineDashPattern = pattern
        self.grayShape.strokeColor = gLightGrayColor.CGColor
        self.grayShape.path = path.CGPath
        self.grayShape.fillColor = UIColor.clearColor().CGColor
        
        self.blueShape = CAShapeLayer()
        self.blueShape.lineWidth = 8
        self.blueShape.lineDashPattern = pattern
        self.blueShape.strokeColor = gBlueColor.CGColor
        self.blueShape.path = path.CGPath
        self.blueShape.fillColor = UIColor.clearColor().CGColor
        
        CATransaction.begin()
        self.blueShape.removeAnimationForKey("Animate Stroke")
        var strokeAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeAnimation.fillMode = kCAFillModeBoth
        strokeAnimation.removedOnCompletion = false
        strokeAnimation.duration = 0.5
        strokeAnimation.fromValue = 0
        strokeAnimation.toValue = toValue
        self.blueShape.addAnimation(strokeAnimation, forKey: "Animate Stroke")
        CATransaction.commit()
        
        self.grayShape.addSublayer(self.blueShape)
        
        self.batteryChargingView.layer.insertSublayer(self.grayShape, atIndex: 0)
    }
    
    func queryCategories() {
    
        println("In function \(__FUNCTION__) in \(self.description) \n")
        
        var query = PFQuery(className: "Category")
        query.cachePolicy = kPFCachePolicyCacheThenNetwork
        query.findObjectsInBackgroundWithBlock() {
            (categories, err) in
            if err == nil {
                self.categories = categories as [PFObject]
                self.categoryCollection.collectionViewLayout.invalidateLayout()
                self.categoryCollection.reloadData()
                self.pageControl.numberOfPages = self.categories.count
            }
        }
    }
    
    func shareRideButtonPressed(sender: AnyObject!) {
        
        println("In function \(__FUNCTION__) in \(self.description) \n")
        
        self.performSegueWithIdentifier("Share Now", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        println("In function \(__FUNCTION__) in \(self.description) \n")
        
        if segue.identifier == "Shortcut To Category" {
            var destController: LocationsTableViewController = segue.destinationViewController as LocationsTableViewController
            destController.queryName = self.queryName
        }
    }
    
    /************************/
    // MARK: Actions
    /************************/
    @IBAction func pageControlTapped(sender: UIPageControl) {
        
        println("In function \(__FUNCTION__) in \(self.description) \n")
        
        var pageWidth = self.categoryCollection.frame.size.width
        var scrollTo = CGPoint(x: pageWidth * CGFloat(sender.currentPage), y: 0)
        self.categoryCollection.setContentOffset(scrollTo, animated: true)
    }
    

    /************************/
    // MARK: Collection View
    /************************/
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        println("In function \(__FUNCTION__) in \(self.description) \n")
        
        return self.categories.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        println("In function \(__FUNCTION__) in \(self.description) \n")
        
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("Category", forIndexPath: indexPath) as UICollectionViewCell
        println("Cell size is \(cell.frame)")
        var imageView: PFImageView = PFImageView(frame: CGRectInset(cell.bounds, 10, 10))
        var maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: imageView.bounds, cornerRadius: 10).CGPath
        imageView.layer.mask = maskLayer
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        if let photo: AnyObject = self.categories[indexPath.item]["photo"] {
            imageView.file = photo as PFFile
            imageView.loadInBackground(nil)
        }
        cell.addSubview(imageView)
        
        let labelHeight: CGFloat = 40
        let label = UILabel(frame: CGRect(x: 20, y: (cell.frame.height - labelHeight - 20), width: 200, height: labelHeight))
        if let name: AnyObject = self.categories[indexPath.item]["name"] {
            label.text = name as? String
            label.font = gSmallBoldFont
            label.textColor = UIColor.whiteColor()
            label.shadowColor = UIColor(hue: 0, saturation: 0, brightness: 0, alpha: 0.5)
        }
        cell.addSubview(label)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        println("In function \(__FUNCTION__) in \(self.description) \n")
        
        self.queryName = self.categories[indexPath.item]["name"] as String
        self.performSegueWithIdentifier("Shortcut To Category", sender: self)
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            
        println("In function \(__FUNCTION__) in \(self.description) \n")
    
        return collectionView.frame.size
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        println("In function \(__FUNCTION__) in \(self.description) \n")
        
        let pageWidth = self.categoryCollection.frame.size.width
        self.pageControl.currentPage = Int(self.categoryCollection.contentOffset.x / pageWidth)
    }
}
