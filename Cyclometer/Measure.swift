//
//  Measure.swift
//  Cyclometer
//
//  Created by Brian on 8/10/16.
//  Copyright © 2016 Brian Glaeske. All rights reserved.
//

import Foundation

typealias MilesPerHour = Double
typealias KilometersPerHour = Double
typealias MetersPerSecond = Double
typealias Miles = Double
typealias Feet = Double
typealias Kilometers = Double
typealias Meters = Double

class Measure {
    static var currentUnits : Units = .imperial
    
    class func velocity(asMPH mps: MetersPerSecond) -> MilesPerHour {
        return mps * 3600 / kMetersInMile
    }

    class func velocity(asKPH mps: MetersPerSecond) -> KilometersPerHour {
        return mps * 3600 / kMetersInKm;
    }

    class func velocity(_ mps: MetersPerSecond) -> Double {
        if Measure.currentUnits == .imperial {
            return Measure.velocity(asMPH: mps)
        } else {
            return Measure.velocity(asKPH: mps)
        }
    }
    
    class func distance(asMiles meters: Meters) -> Miles {
        return meters / kMetersInMile
    }
    
    class func distance(asFeet meters: Meters) -> Feet {
        return meters * kMetersInFeet
    }

    class func distance(asKilometers meters: Meters) -> Kilometers {
        return meters / kMetersInKm
    }
    
    class func distance(_ meters: Meters) -> Double {
        if Measure.currentUnits == .imperial {
            return Measure.distance(asMiles: meters)
        } else {
            return Measure.distance(asKilometers: meters)
        }
    }

    class func distance(smallUnits meters: Meters) -> Double {
        if Measure.currentUnits == .imperial {
            return meters.ft
        } else {
            return meters
        }
    }

    class func pace(_ secondsPerMeter : Double) -> Double {
        if Measure.currentUnits == .imperial {
            return secondsPerMeter / 60 * kMetersInMile
        } else {
            return secondsPerMeter / 60 * kMetersInKm
        }
    }
    
    class var distanceLabel : String {
        get {
            if Measure.currentUnits == .imperial {
                return "Miles"
            } else {
                return "Kilometers"
            }
        }
    }
    
    class var smallDistanceLabel : String {
        get {
            if Measure.currentUnits == .imperial {
                return "Feet"
            } else {
                return "Meters"
            }
        }
    }
    
    class var speedLabel : String {
        get {
            if Measure.currentUnits == .imperial {
                return "mph"
            } else {
                return "kph"
            }
        }
    }
    
    class var paceLabel : String {
        get {
            if Measure.currentUnits == .imperial {
                return "min/mile"
            } else {
                return "min/km"
            }
        }
    }

}
