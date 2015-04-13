//
//  Ride.swift
//  Cyclometer
//
//  Created by Brian on 1/11/15.
//  Copyright (c) 2015 Brian Glaeske. All rights reserved.
//

import Foundation
import CoreMotion
import CoreBluetooth
import CoreLocation


class CylRideManager : NSObject, CLLocationManagerDelegate {

    var locationManager : CLLocationManager!
    var motionManager : CMMotionActivityManager?

    override init() {
        
        super.init()

        locationManager = CLLocationManager()
        locationManager.requestAlwaysAuthorization()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.distanceFilter = kCLDistanceFilterNone

        if (CMMotionActivityManager.isActivityAvailable()) {
            motionManager = CMMotionActivityManager()
        }
    }
    
    deinit {
        locationManager.stopMonitoringSignificantLocationChanges()
        locationManager = nil
        
        motionManager?.stopActivityUpdates()
        motionManager = nil
    }

    func start() {
        var opQ = NSOperationQueue()
        
        motionManager!.startActivityUpdatesToQueue(opQ, withHandler: updateMotion)
    }
    
    /* CoreMotion */
    
    func updateMotion(motionActivity: CMMotionActivity!) -> Void {

        
    }
    

    /* CoreLocation Delegates */
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        NSLog("%d", manager.location.altitude)
    }
 
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        NSLog("We changed")
    }
}