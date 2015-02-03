//
//  CyclometerModel.swift
//  Cyclometer
//
//  Created by Brian on 1/31/15.
//  Copyright (c) 2015 Brian Glaeske. All rights reserved.
//

import Foundation
import CoreData

class Devices: NSManagedObject {
    
    @NSManaged var id: String
    
}

class Ride: NSManagedObject {
    
    @NSManaged dynamic var date: NSDate
    @NSManaged var biometrics: NSOrderedSet
    @NSManaged var locations: NSOrderedSet
    @NSManaged var motions: NSOrderedSet
    @NSManaged var summary: Summary
    
}

class Summary: NSManagedObject {
    
    @NSManaged var cadence_avg: Float
    @NSManaged var cadence_max: Int16
    @NSManaged var distance: Float
    @NSManaged var elevation_gain: Int32
    @NSManaged var elevation_loss: Int32
    @NSManaged var end: NSDate
    @NSManaged var hr_avg: Float
    @NSManaged var hr_max: Int16
    @NSManaged var pace_avg: Float
    @NSManaged var pace_max: Float
    @NSManaged var pace_min: Float
    @NSManaged var speed_avg: Float
    @NSManaged var speed_max: Float
    @NSManaged var start: NSDate
    @NSManaged var time_active: Int64
    @NSManaged var time_total: Int64
    @NSManaged var ride: Ride
    
}

class Biometrics: NSManagedObject {
    
    @NSManaged var bpm: Int16
    @NSManaged var date: NSDate
    @NSManaged var ride: Ride
    
}

class Motion: NSManagedObject {
    
    @NSManaged var cadence: Int16
    @NSManaged var date: NSDate
    @NSManaged var gpsspeed: Double
    @NSManaged var wheelspeed: Double
    @NSManaged var ride: Ride
    
}

class Location: NSManagedObject {
    
    @NSManaged var altitude: Double
    @NSManaged var date: NSDate
    @NSManaged var latitude: Double
    @NSManaged var longitude: Double
    @NSManaged var ride: Ride
    
}
