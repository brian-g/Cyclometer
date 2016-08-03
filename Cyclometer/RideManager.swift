//
//  RideManager.swift
//  Cyclometer
//
//  Created by Brian on 1/11/15.
//  Copyright (c) 2015 Brian Glaeske. All rights reserved.
//

import Foundation
import UIKit
import CoreMotion
import CoreBluetooth
import CoreLocation

protocol RideManagerDelegate : class {
    func locationDidUpdate(locations:[CLLocation]) -> Void
}

class RideManager : NSObject, CLLocationManagerDelegate {

    private var locationManager : CLLocationManager!
    private var lastLocation : CLLocation!
    private var startDate : Date!
    private var stopDate : Date!

    var delegate : RideManagerDelegate!
    var totalDistance : CLLocationDistance = 0
    var coordinates : [CLLocationCoordinate2D] = []
    var plannedRoute : [CLLocationCoordinate2D] = []
    
    var ride = Ride()
    
    override init() {
        
        super.init()

        locationManager = CLLocationManager()

        let authStatus = CLLocationManager.authorizationStatus()
        
        if (authStatus == .denied || authStatus == .restricted) {
            // need to do soemthing here
        } else if (authStatus == .notDetermined) {
            locationManager.requestAlwaysAuthorization()
        }
        
        CLLocationManager.locationServicesEnabled()
        
        locationManager.activityType = .fitness
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.distanceFilter = kCLDistanceFilterNone
        
    }
    
    deinit {
        locationManager.stopUpdatingLocation()
        locationManager = nil
    }

    var duration : TimeInterval {
        get {
            if (startDate != nil) {
                if (stopDate != nil) {
                    return DateInterval(start: startDate, end: stopDate).duration
                } else {
                    return DateInterval(start: startDate, end: Date()).duration
                }
            }
            return 0
        }
    }
    
    var pace : Double {
        get {
            return duration / totalDistance
        }
    }
    
    var average : Double {
        get {
            return totalDistance / duration
        }
    }
    
    func start() -> Bool {
        let authStatus = CLLocationManager.authorizationStatus()
        if (authStatus == .authorizedAlways || authStatus == .authorizedWhenInUse) {
            locationManager.startUpdatingLocation()
        } else {
            return false
        }
        NSLog("Location tracking started")
        
        startDate = Date()
        totalDistance = 0
    
        return true
    }
    
    func stop() -> Bool {
        locationManager.stopUpdatingLocation()
        return true
    }

    /* CoreLocation Delegates */
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if (lastLocation != nil) {
            totalDistance = totalDistance + lastLocation.distance(from: locations.last!)
        }
        lastLocation = locations.last!
        
        if (delegate != nil) {
            delegate.locationDidUpdate(locations: locations)
        }
        coordinates.append(locations.last!.coordinate)
        
    }
 
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        NSLog("BRG: Not sure what the fuck to do here.")
        
    }
}
