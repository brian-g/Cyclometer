//
//  Sensor.swift
//  Cyclometer
//
//  Created by Brian on 1/3/15.
//  Copyright (c) 2015 Brian Glaeske. All rights reserved.
//

import Foundation

protocol SensorProtocol {
    var name : String { get }
}

class Sensor {

    let updateFrequency = 500
    
}

class SensorDemoWheel : Sensor, SensorProtocol {
    let name : String = "Demo Wheel"
    var value : Int = 0
}

class SensorDemoCadence : Sensor, SensorProtocol {
    let name = "Demo Cadence"
    var value = 0
}

class SensorDemoGPS : Sensor, SensorProtocol {
    let name = "Demo GPS"
}

class SensorDemoHR : Sensor, SensorProtocol {
    let name = "Demo HR"
}



class SensorLocation : Sensor, SensorProtocol {
    let name = "Location - GPS, Altitude, Acceleration"
}

class SensorTime : Sensor, SensorProtocol {
    let name = "Time"
}

