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
    case other = 0
    case topShoe, inShoe, hip, frontWheel, leftCrank, rightCrank, leftPedal, rightPedal, frontHub, rearDropout, chainstay, rearWheel, rearHub, chest
    
    func description() -> String {
        switch self {
            case .other: return "Other"
            case .topShoe: return "Top shoe"
            case .inShoe: return "In shoe"
            case .hip: return "Hip"
            case .frontWheel: return "Front wheel"
            case .leftCrank: return "Left crank"
            case .rightCrank: return "Right crank"
            case .leftPedal: return "Left pedal"
            case .rightPedal: return "Right pedal"
            case .frontHub: return "Front hub"
            case .rearDropout: return "Rear dropout"
            case .chainstay: return "Chainstay"
            case .rearWheel: return "Rear wheel"
            case .rearHub: return "Rear hub"
            case .chest: return "Chest"
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

    let type : SensorType = SensorType.wheelAndCrankRPM
    var name : String {
        get {
            return _peripheral.name!
        }
    }
    override var description: String {
        get {
            return "Cycling speed and cadence"
        }
    }
    var connected: Bool = false
    var remembered: Bool = false
    var identifier: UUID {
        get {
            return _peripheral.identifier
        }
    }
    
    class func readCylingFeature(_ data: Data) -> ( wheelrevolutions: Bool, crankrevolutions: Bool) {
        
        var wheel = false
        var crank = false
        
        var buffer : UInt16 = 0x0
        
        (data as NSData).getBytes(&buffer, range:NSMakeRange(0, 2))
        
        if buffer & 0x00 > 0 {
            wheel = true
        }
        
        if buffer & 0x01 > 0 {
            crank = true
        }
        
        return (wheel, crank)
    }

    class func readCylingMeasurement(_ data: Data) {
    

        
    }
    
    class func readSensorLocation(_ data: Data) -> CyclingSensorLocation {
        
        var buffer = CyclingSensorLocation.other
        
        (data as NSData).getBytes(&buffer, length:data.count)
        
        return buffer
    }
    
    init(peripheral : CBPeripheral) {
        
        super.init()
        
        _peripheral = peripheral
        _peripheral.delegate = self
        
    }
    
    var updateWheelRevolutions: ((UInt32) -> Void)?

    var updateCrankRevolutions: ((UInt16) -> Void)?

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        if (service.uuid == CBUUID(string: kBTHR)) {
            NSLog("didDiscoverCharacteristics: \(String(describing: peripheral.name)), Service: \(service.uuid):\(service.uuid.uuidString), " + service.description)
            
            
            let characteristics = service.characteristics
            
            for c in characteristics! {
                NSLog("Characteristic: \(c.uuid.uuidString)")
                
                if (c.uuid.uuidString == kBTHRLocation) {
                    peripheral.readValue(for: c)
                }
                
                if (c.uuid.uuidString == kBTHRMeasurement) {
                    peripheral.setNotifyValue(true, for: c)
                }
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        if let _ = error {
            NSLog("error reading characteristic")
        } else {
            switch characteristic.uuid.uuidString {
            case kBTCSCMeasurement:
                var _ = 0
//                var bpm = HeartRateSensor.readHeartRate(characteristic.value)
//                if var f = updateHeartRate {
//                    f(bpm)
//                }
            case kBTHRLocation:
                NSLog("Location: \(HeartRateSensor.readHeartRateLocation(characteristic.value!).description())")
            default:
                NSLog("WTF")
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        
        if let _ = error {
            NSLog("error")
        } else {
            switch characteristic.uuid.uuidString {
            case kBTCSCMeasurement:
                
                if let v = characteristic.value {
                    let bpm = v
//                    let bpm = CycleSensor.readHeartRate(v)
                    NSLog("Rate: \(bpm)")
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
