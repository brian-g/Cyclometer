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
import CoreLocation

protocol RideManagerDelegate : class {
    func locationDidUpdate(locations:[CLLocation]) -> Void
    func rideDidPause() -> Void
    func rideDidResume() -> Void
    func rideError(_ r : RideManagerError) -> Void
}

struct Period {
    var start : Date
    var end : Date?
    
    mutating func closePeriod() {
        end = Date()
    }
}

enum RideManagerError {
    case NoError
    case Location_Denied
    case Location_NotAvailable
}

class RideManager : NSObject, CLLocationManagerDelegate, RideProtocol {

    let autoPauseTime : TimeInterval = 2
    
    private var locationManager : CLLocationManager?
    private var lastLocation : CLLocation!
    
    var rideInfo = RideInfo()
    
    var delegate : RideManagerDelegate!

    var coordinates : [CLLocationCoordinate2D] = []
    var plannedRoute : [CLLocationCoordinate2D] = []
    
    var ride = Ride()
    
    override init() {
        super.init()
    }
    
    deinit {
        locationManager!.stopUpdatingLocation()
        locationManager = nil
    }
    
    private func initializeLocationService() -> RideManagerError {
        
        if locationManager == nil {
            locationManager = CLLocationManager()
            
            let authStatus = CLLocationManager.authorizationStatus()
            
            if (authStatus == .denied || authStatus == .restricted) {
                NSLog("authStatus for CLLocationManager was denied");

            } else if (authStatus == .notDetermined) {
                locationManager!.requestAlwaysAuthorization()
            } else if (authStatus == .authorizedWhenInUse) {
                locationManager!.requestWhenInUseAuthorization()
            } else if (authStatus == .authorizedAlways) {
                locationManager!.requestAlwaysAuthorization()
            }
            
            CLLocationManager.locationServicesEnabled()
            
            locationManager!.activityType = .fitness
            locationManager!.desiredAccuracy = kCLLocationAccuracyBest
            locationManager!.delegate = self
            locationManager!.distanceFilter = kCLDistanceFilterNone
        }
        
        return RideManagerError.NoError
    }
    
    private func start() -> RideManagerError {
        let authStatus = CLLocationManager.authorizationStatus()
        if (authStatus == .authorizedAlways || authStatus == .authorizedWhenInUse) {
            _ = initializeLocationService()
            locationManager!.startUpdatingLocation()
        } else {
            return RideManagerError.Location_Denied
        }

        rideInfo.clearStats()
        rideInfo.start()

        return RideManagerError.NoError
    }
    
    private func pause() -> Bool {
        rideInfo.end()
        return true
    }

    private func stop() -> Bool {

        rideInfo.end()
        // 
        // duh lots to do here
        //
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
                        if start() == RideManagerError.Location_Denied {
                            delegate!.rideError(RideManagerError.Location_Denied)
                        }
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
        
        if let zeroSpeed = rideInfo.speedBecameZeroOn {
            if state != .autoPause && zeroSpeed.timeIntervalSinceNow < -autoPauseTime {
                state = .autoPause
                rideInfo.end()
            }
            
            if state == .autoPause && rideInfo.speed > 0 {
                state = .play
                rideInfo.start()
            }
        }
    }
 
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch(status) {
            case .notDetermined:
                NSLog("Location authorization: not determined")
            case .restricted:
                NSLog("Location authroization: restricted")
            case .authorizedAlways:
                NSLog("Location authorization: always")
            case .authorizedWhenInUse:
                NSLog("Location authorization: when in use")
            case .denied:
                NSLog("Location authorization: denied")
        }
    }
}
