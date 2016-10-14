//
//  Protocols.swift
//  Cyclometer
//
//  Created by Brian on 2/3/15.
//  Copyright (c) 2015 Brian Glaeske. All rights reserved.
//

import Foundation
import CoreLocation

protocol RideProtocol {
    var speed : Double { get }
    var avgSpeed : Double { get }
    var maxSpeed : Double { get }
    
    var location : CLLocation { get }
    var duration : TimeInterval { get }
    var activeDuration : TimeInterval { get }
    var pace : Double { get }

    var heartRate : Double { get }
    var avgHeartRate : Double { get }
    var maxHeartRate : Double { get }
    
    var state : RideState { get set }
    
}
