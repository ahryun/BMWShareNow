//
//  NavigationViewController.swift
//  BMWShareNow
//
//  Created by Jasper Sone on 1/11/15.
//  Copyright (c) 2015 Papafish. All rights reserved.
//

import UIKit
import MapKit

class NavigationViewController: UIViewController {

    @IBOutlet weak var pickUpPassenger: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    var geoLocationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.hidesBackButton = true
        self.geoLocationManager = CLLocationManager()
        self.geoLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.geoLocationManager.distanceFilter = 300
        self.geoLocationManager.delegate = self
        self.geoLocationManager.requestWhenInUseAuthorization()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        self.setUpButton()
    }
    
    func setUpButton() {
        
        println("In function \(__FUNCTION__) in \(self.description) \n")
        
        self.pickUpPassenger.addTarget(self, action: Selector("pickedUpPassenger:"), forControlEvents: UIControlEvents.TouchUpInside)
        var shape = CAShapeLayer()
        shape.path = UIBezierPath(roundedRect: self.pickUpPassenger.bounds, cornerRadius: self.pickUpPassenger.frame.height / 2).CGPath
        shape.lineWidth = 4.0
        shape.strokeColor = UIColor.whiteColor().CGColor
        shape.fillColor = UIColor.clearColor().CGColor
        self.pickUpPassenger.layer.addSublayer(shape)
        self.pickUpPassenger.setTitle("Picked Up Peter", forState: .Normal)
        self.pickUpPassenger.titleLabel?.font = gMediumFont
        self.pickUpPassenger.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    }
    
    func setUpMap() {
        
        println("In function \(__FUNCTION__)")
        
        self.mapView.showsUserLocation = true
        weak var weakSelf = self
        self.mapView.delegate = weakSelf
        self.mapView.zoomEnabled = true
        self.mapView.showAnnotations([self.mapView.userLocation], animated: false)
        let coordinates = CLLocationCoordinate2D(latitude: 37.786735, longitude: -122.399914)
        self.mapView.addAnnotation(NumberedMapPin(coordinate: coordinates))
        let destCoordinates = CLLocationCoordinate2D(latitude: 37.785900, longitude: -122.406509)
        self.mapView.addAnnotation(NumberedMapPin(coordinate: destCoordinates, ifDest: true))
        self.zoomToLocation(coordinate: self.mapView.userLocation.coordinate, animated: false)
    }
    
    func zoomToLocation(#coordinate: CLLocationCoordinate2D!, animated: Bool) {
        
        println("In function \(__FUNCTION__)")
        
        if (coordinate != nil) {
            var region: MKCoordinateRegion = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            region = self.mapView.regionThatFits(region)
            self.mapView.setRegion(region, animated: animated)
        }
    }
    
    func pickedUpPassenger(sender: AnyObject!) {
        
        println("In function \(__FUNCTION__) in \(self.description) \n")
        
        if self.pickUpPassenger.tag == 0 {
            PFCloud.callFunctionInBackground("pickUp", withParameters: ["rideID": "zyfKT7Hq95"], block: nil)
            let alertView: UIAlertView = UIAlertView(title: "Cool!", message: "We will send the destination navigation information to your vehidle", delegate: nil, cancelButtonTitle: "OK")
            alertView.show()
            self.pickUpPassenger.setTitle("Arrived at Destination", forState: .Normal)
            self.pickUpPassenger.tag = 1
        } else {
            PFCloud.callFunctionInBackground("endTrip", withParameters: ["rideID": "zyfKT7Hq95"], block: nil)
            self.performSegueWithIdentifier("Unwind To Main", sender: self)
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

let gNumberedMapPinKey          = "numberedMapPinID"
extension NavigationViewController: MKMapViewDelegate {
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        println("In function \(__FUNCTION__)")
        
        if annotation.isEqual(mapView.userLocation) { return nil }
        
        let anAnnotation: NumberedMapPin = annotation as NumberedMapPin
        if let annotationView = self.mapView.dequeueReusableAnnotationViewWithIdentifier(gNumberedMapPinKey) {
            annotationView.annotation = anAnnotation
            return annotationView
        } else {
            return anAnnotation.createAnnotationView()
        }
    }
    
    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
        mapView.centerCoordinate = mapView.userLocation.coordinate
    }
}

extension NavigationViewController: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        self.setUpMap()
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        println("In function \(__FUNCTION__)")
        
        if status == CLAuthorizationStatus.AuthorizedWhenInUse {
            self.geoLocationManager.startUpdatingLocation()
        }
    }
}

class NumberedMapPin : NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var ifDest: Bool
    
    init(coordinate: CLLocationCoordinate2D, ifDest: Bool = false) {
        
        println("In function \(__FUNCTION__)")
        
        self.coordinate = coordinate
        self.ifDest = ifDest
        
        super.init()
    }
    
    func createAnnotationView() -> MKAnnotationView {
        
        println("In function \(__FUNCTION__)")
        
        let anAnnotationView: MKAnnotationView = MKAnnotationView(annotation: self, reuseIdentifier: gNumberedMapPinKey)
        anAnnotationView.image = UIImage(named: "iconSolidBlack")
        var image = UIImageView(image: UIImage(named: self.ifDest ? "trader" : "peter"))
        image.frame = CGRectOffset(CGRectInset(anAnnotationView.bounds, 14, 14), 0, -8)
        var maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(ovalInRect: image.bounds).CGPath
        image.layer.mask = maskLayer
        anAnnotationView.addSubview(image)
        
        return anAnnotationView
    }
}
