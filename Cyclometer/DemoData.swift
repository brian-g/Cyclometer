//
//  DemoData.swift
//  Cyclometer
//
//  Created by Brian on 12/23/15.
//  Copyright © 2015 Brian Glaeske. All rights reserved.
//

import Foundation
import CoreData


func createDemoData(_ managedContext : NSManagedObjectContext) {
    
//    let ride = NSEntityDescription.insertNewObject(forEntityName: "Ride", into: managedContext) as! Ride
    let ride = Ride(context: managedContext)
    let summary = NSEntityDescription.insertNewObject(forEntityName: "Summary", into: managedContext) as! Summary
    
    summary.elevation_gain = 15
    summary.elevation_loss = 15
    summary.distance = 24140.16
    summary.speed_avg = 6.71
    summary.speed_max = 13.4
    summary.hr_avg = 78
    summary.hr_max = 130
    summary.pace_avg = 10
    summary.pace_avg = 1.9
    summary.pace_max = 2.3
    summary.pace_min = 1.0
    summary.cadence_avg = 80
    summary.cadence_max = 130
    summary.start = Date()
    summary.end = Date().addingTimeInterval(6756.0)
    summary.time_active = 5810
    summary.time_total = 6034
    
    ride.date = Date()
    ride.summary = summary
    
    summary.ride = ride
    
    for _ in 1...15 {
        let bio = NSEntityDescription.insertNewObject(forEntityName: "Biometrics", into: managedContext) as! Biometrics
        bio.date = Date(timeIntervalSinceNow: 5)
        bio.ride = ride
        bio.bpm = 78
    }
    
    for _ in 1...20 {
        let motion = NSEntityDescription.insertNewObject(forEntityName: "Motion", into: managedContext) as! Motion
        
        motion.date = Date()
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
