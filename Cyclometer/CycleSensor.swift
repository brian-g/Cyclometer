//
//  CycleSensor.swift
//  Cyclometer
//
//  Created by brian on 4/12/15.
//  Copyright (c) 2015 Brian Glaeske. All rights reserved.
//

import Foundation
import CoreBluetooth

enum CyclingSensorLocation : UInt8 {
    case Other = 0
    case TopShoe, InShoe, Hip, FrontWheel, LeftCrank, RightCrank, LeftPedal, RightPedal, FrontHub, RearDropout, Chainstay, RearWheel, RearHub, Chest
    
    func description() -> String {
        switch self {
        case .Other: return "Other"
        case .TopShoe: return "Top shoe"
        case .InShoe: return "In shoe"
        case .Hip: return "Hip"
        case .FrontWheel: return "Front wheel"
        case .LeftCrank: return "Left crank"
        case .RightCrank: return "Right crank"
        case .LeftPedal: return "Left pedal"
        case .RightPedal: return "Right pedal"
        case .FrontHub: return "Front hub"
        case .RearDropout: return "Rear dropout"
        case .Chainstay: return "Chainstay"
        case .RearWheel: return "Rear wheel"
        case .RearHub: return "Rear hub"
        case .Chest: return "Chest"
        }
    }
}

struct CyclingMeasurement {
    var flags : UInt8
    var wheelRevolutions : UInt32
    var lastWheelTime : UInt16
    var crankRevolutions : UInt16
    var lastCrankTime : UInt16
}

class CycleSensor : NSObject, CBPeripheralDelegate {
    
    let deviceName = "Cycling Speed and Cadence"
    
    weak var _peripheral : CBPeripheral!
    
    class func readCylingFeature(data: NSData) -> ( wheelrevolutions: Bool, crankrevolutions: Bool) {
        
        var wheel = false
        var crank = false
        
        var buffer : UInt16 = 0x0
        
        data.getBytes(&buffer, range:NSMakeRange(0, 2))
        
        if buffer & 0x00 > 0 {
            wheel = true
        }
        
        if buffer & 0x01 > 0 {
            crank = true
        }
        
        return (wheel, crank)
    }

    class func readCylingMeasurement(data: NSData) {
    

        
    }
    
    
    class func readSensorLocation(data: NSData) -> CyclingSensorLocation {
        
        var buffer = CyclingSensorLocation.Other
        
        data.getBytes(&buffer, length:data.length)
        
        return buffer
    }
    
    init(peripheral : CBPeripheral) {
        
        super.init()
        
        _peripheral = peripheral
        _peripheral.delegate = self
        
    }
    
    var updateHeartRate : ((UInt16) -> Void)?



}
