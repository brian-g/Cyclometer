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

    var delegate : RideManagerDelegate!
    var totalDistance : CLLocationDistance = 0
    var coordinates : [CLLocationCoordinate2D] = []
    var plannedRoute : [CLLocationCoordinate2D] = []
    var activePeriods : [Period] = []
    
    var ride = Ride()
    

    override init() {

        speed = 0

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

    var speed : Double {
        didSet {
            if speed == 0 && state == .play {
                if (UserDefaults.standard.bool(forKey: kAutoPause)) {
                    state = .pause
                    delegate!.rideDidPause()
                }
            } else if speed > 0 && state == .pause {
                if (UserDefaults.standard.bool(forKey: kAutoPause)) {
                    state = .play
                    delegate!.rideDidResume()
                }
            }
        }
    }


    var avgSpeed : Double {
        get {
            return totalDistance / duration
        }
    }

    var maxSpeed: Double = 0.0;
    
    var location: CLLocation = CLLocation()
    
    var duration : TimeInterval {
        get {
            var x : TimeInterval = 0
            
            NSLog("Number of periods \(activePeriods.count)")
            for i in activePeriods {
                if (i.end != nil) {
                    x = x + DateInterval(start: i.start, end: i.end!).duration
                } else {
                    x = x + DateInterval(start: i.start, end: Date()).duration
                }
            }

            return x;
        }
        set {
            activePeriods.removeAll()
        }
    }
    
    var activeDuration: TimeInterval = 0.0
    
    var pace : Double {
        get {
            return duration / totalDistance
        }
    }
    
    var heartRate: Double = 0.0
    var avgHeartRate: Double = 0.0
    var maxHeartRate: Double = 0.0
    
    private func start() -> Bool {
        let authStatus = CLLocationManager.authorizationStatus()
        if (authStatus == .authorizedAlways || authStatus == .authorizedWhenInUse) {
            locationManager.startUpdatingLocation()
        } else {
            return false
        }

        totalDistance = 0
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
            }
        }
    }
    
    private func stop() -> Bool {
        locationManager.stopUpdatingLocation()
        duration = 0
        
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
        speed = lastLocation.speed
    }
 
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        NSLog("BRG: Not sure what the fuck to do here.")
        
    }
}
