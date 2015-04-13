//
//  Tools.swift
//  Cyclometer
//
//  Created by Brian on 3/29/15.
//  Copyright (c) 2015 Brian Glaeske. All rights reserved.
//

import Foundation
import UIKit
import CoreMotion
import CoreLocation

class JunkTools : UIViewController, CLLocationManagerDelegate {

    
    var motionActivity : CMMotionActivityManager!
    var altimeter : CMAltimeter!
    var locationManager : CLLocationManager!
    
    @IBOutlet weak var coreMotionStatus: UILabel!
    @IBOutlet weak var coreMotionConfidence: UILabel!
    @IBOutlet weak var altitude: UILabel!
    @IBOutlet weak var verticalAccuracy: UILabel!
    @IBOutlet weak var elevation: UILabel!
    @IBOutlet weak var floor: UILabel!
    
    @IBOutlet weak var bestSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func toggleCoreMotion(sender: AnyObject) {

        var opQ = NSOperationQueue()
        
        if ((sender as! UISwitch).on) {
            if (CMMotionActivityManager.isActivityAvailable()) {
                motionActivity = CMMotionActivityManager()
                NSLog("Starting Core Motion")
                motionActivity!.startActivityUpdatesToQueue(opQ, withHandler: updateMotion)

            } else {
                let alert = UIAlertController(title: "No motion", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
                self.presentViewController(alert, animated: true, completion: nil)
            }

            if (CMAltimeter.isRelativeAltitudeAvailable()) {
                altimeter = CMAltimeter()
                altimeter.startRelativeAltitudeUpdatesToQueue(opQ, withHandler: updateAltitude)
            } else {
                let alert = UIAlertController(title: "No altitude", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
                self.presentViewController(alert, animated: true, completion: nil)
                
            }
        } else {
            motionActivity!.stopActivityUpdates()
            altimeter.stopRelativeAltitudeUpdates()
            altitude.text = ""
            coreMotionConfidence.text = ""
            coreMotionStatus.text = "off"
        }
    }
    
    @IBAction func toggleCoreLocation(sender: AnyObject) {
        
        if ((sender as! UISwitch).on) {
            
            if (CLLocationManager.locationServicesEnabled()) {
                locationManager = CLLocationManager()
                locationManager.delegate = self
                if CLLocationManager.authorizationStatus() == .NotDetermined {
                    locationManager.requestAlwaysAuthorization()
                }
            } else {
                let alert = UIAlertController(title: "No location services", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
                self.presentViewController(alert, animated: true, completion: nil)
                
            }
        } else {
            
        }
    }
    
    
    /* CoreMotion */
    func updateAltitude(altitudeData: CMAltitudeData!, error: NSError!) -> Void {
    
        if (altitudeData != nil && altitudeData.relativeAltitude != nil) {
            var x = altitudeData.relativeAltitude
            altitude.text = "Altitude:" + x.stringValue + " meters"
        } else {
            altitude.text = "No altitude"
        }
    }
    
    
    func updateMotion(motionActivity: CMMotionActivity!) -> Void {
        
        NSLog("coremotion activity")
        
        if (motionActivity.automotive) {
            coreMotionStatus.text = "Automotive"
        } else if (motionActivity.cycling) {
            coreMotionStatus.text = "Biking"
        } else if (motionActivity.walking) {
            coreMotionStatus.text = "Walking"
        } else if (motionActivity.running) {
            coreMotionStatus.text = "Running"
        } else if (motionActivity.stationary) {
            coreMotionStatus.text = "Stationary"
        } else if (motionActivity.unknown) {
            coreMotionStatus.text = "Unknown"
        } else {
            coreMotionStatus.text = "Really unknown"
        }
        
        switch motionActivity.confidence {
            case CMMotionActivityConfidence.High:
                coreMotionConfidence.text = "High"

            case CMMotionActivityConfidence.Medium:
                coreMotionConfidence.text = "Medium"
                
            case .Low:
                coreMotionConfidence.text = "Low"
        }
    }
    
    @IBOutlet weak var acceleration: UILabel!
    
    /* Core Location */
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        NSLog("location")
        var loc = (locations.last as! CLLocation)
        
        verticalAccuracy.text = "Vert: " + loc.verticalAccuracy.description + " Hor: " + loc.horizontalAccuracy.description

        var feetAbove = loc.altitude / 0.3048
        
        elevation.text = "Elevation: " + feetAbove.description + " feet"

        var mph = loc.speed * 3600 / 1609.344
        
        acceleration.text = mph.description + " mph"
        
        floor.text = "Floor: " + CLFloor().level.description

    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {

        if (status == CLAuthorizationStatus.AuthorizedAlways) {

            if (bestSwitch.on) {
                locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            } else {
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
            }
            locationManager.distanceFilter = 0.0
            locationManager.activityType = CLActivityType.Fitness

        
            locationManager.startUpdatingLocation()

        } else {
            switch status {
                case CLAuthorizationStatus.AuthorizedAlways:
                    NSLog("always")
                case CLAuthorizationStatus.AuthorizedWhenInUse:
                    NSLog("in use")
                case CLAuthorizationStatus.Denied:
                    NSLog("deniced")
                case CLAuthorizationStatus.NotDetermined:
                    NSLog("Not determined")
                case CLAuthorizationStatus.Restricted:
                    NSLog("Restructed")
            }
        }
    }
}