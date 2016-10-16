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
    func rideDidPause() -> Void
    func rideDidResume() -> Void
}

struct Period {
    var start : Date
    var end : Date?
    
    mutating func closePeriod() {
        end = Date()
    }
}


class RideManager : NSObject, CLLocationManagerDelegate, RideProtocol {

    private var locationManager : CLLocationManager!
    private var lastLocation : CLLocation!
    private var activePeriods : [Period] = []
    
    var rideInfo : RideInfo
    
    var delegate : RideManagerDelegate!

    var coordinates : [CLLocationCoordinate2D] = []
    var plannedRoute : [CLLocationCoordinate2D] = []
    
    var ride = Ride()
    

    override init() {

        rideInfo = RideInfo()
        
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
        
    private func start() -> Bool {
        let authStatus = CLLocationManager.authorizationStatus()
        if (authStatus == .authorizedAlways || authStatus == .authorizedWhenInUse) {
            locationManager.startUpdatingLocation()
        } else {
            return false
        }

        rideInfo.clearStats()
        activePeriods.append(Period(start: Date(), end: nil))
        
        return true
    }
    
    private func pause() -> Bool {
        if (activePeriods.count > 1) {
            activePeriods[activePeriods.count - 1].closePeriod()
            NSLog("Paused")
        }
        
        return true
    }

    private func stop() -> Bool {

        rideInfo.clearStats()
        return true
    }
    
    var state : RideState = .stop {
        willSet {
            switch newValue {
                case .pause:
                    _ = pause()
                case .stop:
                    _ = stop()
                case .play:
                    if state != .play {
                        _ = start()
                    }
                case .autoPause:
                    _ = pause();
            }
        }
    }

    /* CoreLocation Delegates */
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if (lastLocation != nil && state != .pause && state != .autoPause) {
            rideInfo.totalDistance += lastLocation.distance(from: locations.last!)
            coordinates.append(locations.last!.coordinate)
        }
        lastLocation = locations.last!
        
        if (delegate != nil) {
            delegate.locationDidUpdate(locations: locations)
        }
        rideInfo.speed = lastLocation.speed
        rideInfo.elevation = lastLocation.altitude
    }
 
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        NSLog("BRG: Not sure what the fuck to do here.")
        
    }
}
