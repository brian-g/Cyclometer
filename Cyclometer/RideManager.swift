//
//  Ride.swift
//  Cyclometer
//
//  Created by Brian on 1/11/15.
//  Copyright (c) 2015 Brian Glaeske. All rights reserved.
//

import Foundation
import CoreMotion
import CoreBluetooth

var mm: CMMotionManager?
var ble: CBCentralManager?

class RideManager {

    init() {



    }
    
    deinit {
        mm?.stopAccelerometerUpdates()
        mm = nil
    }
    
    func start() {
        mm = CMMotionManager()
        mm?.startAccelerometerUpdates()
        //        ble = CBCentralManager(delegate: self, queue: nil)
    }
    
    func pause() {
        
    }
    
    func stop() {
        
    }
}