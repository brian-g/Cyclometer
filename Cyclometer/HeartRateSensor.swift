//
//  CylSensorHeartRate.swift
//  Cyclometer
//
//  Created by brian on 4/3/15.
//  Copyright (c) 2015 Brian Glaeske. All rights reserved.
//

import Foundation
import CoreBluetooth

enum HeartRateSensorLocation : UInt8 {
    case Other = 0
    case Chest, Wrist, Finger, Hand, EarLobe, Foot
    
    func description() -> String {
        switch self {
            case .Other: return "Other"
            case .Chest: return "Chest"
            case .Finger: return "Finger"
            case .Wrist: return "Wrist"
            case .Hand: return "Hand"
            case .EarLobe: return "Ear lobe"
            case .Foot: return "Foot"
        }
    }
}

class HeartRateSensor : NSObject, CBPeripheralDelegate, Sensor {

    weak var _peripheral : CBPeripheral!

    let type : SensorType = SensorType.HeartRate
    var name : String {
        get {
            return _peripheral.name!
        }
    }
    override var description: String {
        get {
            return location.description() + " heart rate monitor"
        }
    }
    var connected: Bool = false
    var remembered: Bool = false
    var identifier: NSUUID {
        get {
            return _peripheral.identifier
        }
    }
    var location : HeartRateSensorLocation = .Other
    
    class func readHeartRate(data : NSData) -> UInt16 {
        
        var buffer = [UInt8](count: data.length, repeatedValue: 0x00)
        data.getBytes(&buffer, length: buffer.count)
        
        var bpm:UInt16?
        
        if (buffer.count >= 2) {
            if (buffer[0] & 0x01 == 0){
                bpm = UInt16(buffer[1]);
            } else {
                bpm = UInt16(buffer[1]) << 8
                bpm =  bpm! | UInt16(buffer[2])
            }
        }
        
        if let actualBpm = bpm {
            return actualBpm
        } else {
            return bpm!
        }
    }
    
    class func readHeartRateLocation(data: NSData) -> HeartRateSensorLocation {
        
        var buffer = HeartRateSensorLocation.Other
        
        data.getBytes(&buffer, length:data.length)
        
        return buffer
    }
    
    init(peripheral : CBPeripheral) {
 
        super.init()

        _peripheral = peripheral
        _peripheral.delegate = self

        
     }
    
    var updateHeartRate : ((UInt16) -> Void)?
    
    /* These 2 should never get called because of how I'm fucking with the delegate */
    func peripheral(peripheral: CBPeripheral, didDiscoverIncludedServicesForService service: CBService, error: NSError?) {
        
        NSLog("HRSensor: Found \(peripheral.name): service: \(service.description)")
        
    }
    
    func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
        NSLog("HRSensor didDiscoverServices")
        
        for service in peripheral.services! {
            peripheral.discoverCharacteristics(nil, forService: service)
        }
    }
    
    
    func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?) {
        
        if (service.UUID == CBUUID(string: kBTHR)) {
            NSLog("didDiscoverCharacteristics: \(peripheral.name), Service: \(service.UUID):\(service.UUID.UUIDString), " + service.description)
            
            
            let characteristics = service.characteristics

            for c in characteristics! {
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
    
    func peripheral(peripheral: CBPeripheral, didUpdateValueForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        
        if let _ = error {
            NSLog("error reading characteristic")
        } else {
            switch characteristic.UUID.UUIDString {
                case kBTHRMeasurement:
                    
                    let bpm = HeartRateSensor.readHeartRate(characteristic.value!)
                    if let f = updateHeartRate {
                        f(bpm)
                    }
                case kBTHRLocation:
                    location = HeartRateSensor.readHeartRateLocation(characteristic.value!)

                default:
                    NSLog("WTF")
            }
        }
    }

    func peripheral(peripheral: CBPeripheral, didUpdateNotificationStateForCharacteristic characteristic: CBCharacteristic, error: NSError?) {

        if let _ = error {
            NSLog("error")
        } else {
            switch characteristic.UUID.UUIDString {
                case kBTHRMeasurement:
                
                    if let v = characteristic.value {
                        let bpm = HeartRateSensor.readHeartRate(v)
                        NSLog("Rate: \(bpm)")
                        if let f = updateHeartRate {
                            f(bpm)
                        }
                    }
                default:
                    NSLog("WTF")
            }
        }
    
    }
    
}