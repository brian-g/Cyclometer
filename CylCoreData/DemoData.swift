//
//  DemoData.swift
//  Cyclometer
//
//  Created by Brian on 12/23/15.
//  Copyright © 2015 Brian Glaeske. All rights reserved.
//

import Foundation
import CoreData


func createDemoData(managedContext : NSManagedObjectContext) {
    
    let ride = NSEntityDescription.insertNewObjectForEntityForName("Ride", inManagedObjectContext: managedContext) as! Ride
    let summary = NSEntityDescription.insertNewObjectForEntityForName("Summary", inManagedObjectContext: managedContext) as! Summary
    
    summary.elevation_gain = 500
    summary.elevation_loss = 301
    summary.distance = 30
    summary.speed_avg = 15.5
    summary.speed_max = 32.9
    summary.hr_avg = 78
    summary.hr_max = 130
    summary.pace_avg = 10
    summary.pace_avg = 1.9
    summary.pace_max = 2.3
    summary.pace_min = 1.0
    summary.cadence_avg = 80
    summary.cadence_max = 130
    summary.start = NSDate()
    summary.end = NSDate(timeIntervalSinceNow: 10800.0)
    summary.time_active = 10353
    summary.time_total = 10800
    
    ride.date = NSDate()
    ride.summary = summary
    
    summary.ride = ride
    
    var biometrics = [Biometrics]()
    
    for i in 1...15 {
        let bio = NSEntityDescription.insertNewObjectForEntityForName("Biometrics", inManagedObjectContext: managedContext) as! Biometrics
        bio.date = NSDate(timeIntervalSinceNow: 5)
        bio.ride = ride
        bio.bpm = 78
    }
    
    var motion = [Motion]()
    
    for i in 1...20 {
        let motion = NSEntityDescription.insertNewObjectForEntityForName("Motion", inManagedObjectContext: managedContext) as! Motion
        
        motion.date = NSDate()
        motion.cadence = 78
        motion.gpsspeed = 15.6
        motion.wheelspeed = 15.5
        motion.ride = ride
        
    }
    
    
    var error: NSError?
    do {
        try managedContext.save()
    } catch let error1 as NSError {
        error = error1
        NSLog("Could not save \(error), \(error?.userInfo)")
    }
    
}
