//
//  RideInfo.swift
//  Cyclometer
//
//  Created by Brian on 10/15/16.
//  Copyright © 2016 Brian Glaeske. All rights reserved.
//

import Foundation
import CoreLocation

struct RideInfo {
    
    private var _descent : CLLocationDistance = 0
    private var _ascent : CLLocationDistance = 0
    private var _maxSpeed : Double = 0
    private var _maxHeartRate : Int = 0
    private var _startTime : Date?
    private var _periodStart : Date?
    private var _hrSamples : Int = 0
    private var _hrSum : Int = 0
    private var _elevationSet = false
    private var _activeDuration : TimeInterval = 0
    
    var lastUpdate : Date?
    var speedBecameZeroOn : Date?

    var speed : Double = 0.0 {
        didSet {
            if speed > maxSpeed {
                _maxSpeed = speed
            }
            
            lastUpdate = Date()
        }
        
        willSet {
            if newValue == 0 && speed > 0 {
                speedBecameZeroOn = Date()
            } else if newValue > 0 && speed == 0 && speedBecameZeroOn != nil {
                speedBecameZeroOn = nil
            }
        }
    }
    
    var avgSpeed : Double {
        get {
            return activeDuration != 0 ? totalDistance / activeDuration : 0
        }
    }
    
    var maxSpeed : Double {
        get {
            return _maxSpeed
        }
    }
    
    var duration : TimeInterval {
        get {
            if _startTime != nil {
                return -_startTime!.timeIntervalSinceNow
            } else {
                return 0
            }
        }
    }
    
    var activeDuration : TimeInterval {
        get {
            return _activeDuration + (_periodStart != nil ? -_periodStart!.timeIntervalSinceNow : 0)
        }
    }

    var pace : Double {
        get {
            return totalDistance > 0 ? activeDuration / totalDistance : 0
        }
    }
    
    var heartRate: Int = 0 {
        didSet {
            if heartRate > _maxHeartRate {
                _maxHeartRate = heartRate
            }
            _hrSum += heartRate
            _hrSamples += 1
        }
    }
    
    var avgHeartRate: Double {
        get {
            return _hrSamples != 0 ? Double(_hrSum) / Double(_hrSamples) : 0
        }
    }
    
    var maxHeartRate: Int {
        get {
            return _maxHeartRate
        }
    }
    
    var totalDistance : CLLocationDistance = 0
    
    var elevation : CLLocationDistance = 0 {
        willSet {
            if _elevationSet {
                if newValue >= elevation {
                    _ascent += (newValue - elevation)
                } else {
                    _descent += (elevation - newValue)
                }
            }
        }
        
        didSet {
            _elevationSet = true
        }
    }
    
    var ascent : CLLocationDistance {
        get {
            return _ascent
        }
    }
    
    var descent : CLLocationDistance {
        get {
            return _descent
        }
    }
    
    mutating func clearStats() {
        _activeDuration = 0
        totalDistance = 0
        elevation = 0
        lastUpdate = nil
        speedBecameZeroOn = nil
        _startTime = nil
        _periodStart = nil
        _hrSamples = 0
        _hrSum = 0
        _maxHeartRate = 0
        _elevationSet = false
        _ascent = 0
        _descent = 0
        _maxSpeed = 0
    }
    
    mutating func start() {
        if _startTime == nil {
            _startTime = Date()
            _periodStart = _startTime
        }
    }
    
    mutating func end() {
        if _startTime != nil {
            _activeDuration += Date().timeIntervalSince(_startTime!)
            _periodStart = nil
        }
    }
}
