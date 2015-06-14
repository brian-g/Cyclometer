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

class CycleSensor : NSObject, CBPeripheralDelegate, Sensor {
    
    weak var _peripheral : CBPeripheral!

    let type : SensorType = SensorType.WheelAndCrankRPM
    var name : String {
        get {
            return _peripheral.name
        }
    }
    override var description: String {
        get {
            return "Cycling speed and cadence"
        }
    }
    var connected: Bool = false
    var remembered: Bool = false
    var identifier: NSUUID {
        get {
            return _peripheral.identifier
        }
    }
    
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
    
    var updateWheelRevolutions: ((UInt32) -> Void)?

    var updateCrankRevolutions: ((UInt16) -> Void)?

    func peripheral(peripheral: CBPeripheral!, didDiscoverCharacteristicsForService service: CBService!, error: NSError!) {
        
        if (service.UUID == CBUUID(string: kBTHR)) {
            NSLog("didDiscoverCharacteristics: \(peripheral.name), Service: \(service.UUID):\(service.UUID.UUIDString), " + service.description)
            
            
            var characteristics = service.characteristics
            
            for c in characteristics as! [CBCharacteristic] {
                NSLog("Characteristic: \(c.UUID.UUIDString)")
                
                if (c.UUID.UUIDString == kBTHRLocation) {
                    peripheral.readValueForCharacteristic(c)
                }
                
                if (c.UUID.UUIDString == kBTHRMeasurement) {
                    peripheral.setNotifyValue(true, forCharacteristic: c)
                }
            }
        }
    }
    
    func peripheral(peripheral: CBPeripheral!, didUpdateValueForCharacteristic characteristic: CBCharacteristic!, error: NSError!) {
        
        if let actualError = error {
            NSLog("error reading characteristic")
        } else {
            switch characteristic.UUID.UUIDString {
            case kBTCSCMeasurement:
                var cx = 0
//                var bpm = HeartRateSensor.readHeartRate(characteristic.value)
//                if var f = updateHeartRate {
//                    f(bpm)
//                }
            case kBTHRLocation:
                NSLog("Location: \(HeartRateSensor.readHeartRateLocation(characteristic.value).description())")
            default:
                NSLog("WTF")
            }
        }
    }
    
    func peripheral(peripheral: CBPeripheral!, didUpdateNotificationStateForCharacteristic characteristic: CBCharacteristic!, error: NSError!) {
        
        if let actualError = error {
            NSLog("error")
        } else {
            switch characteristic.UUID.UUIDString {
            case kBTCSCMeasurement:
                
                if var v = characteristic.value {
//                    var bpm = CycleSensor.readHeartRate(v)
//                    NSLog("Rate: \(bpm)")
//                    if var f = updateWheelRevolutions {
//                        f(34)
//                    }
                }
            default:
                NSLog("WTF")
            }
        }
        
    }

}
