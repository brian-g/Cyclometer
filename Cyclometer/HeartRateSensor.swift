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
    case other = 0
    case chest, wrist, finger, hand, earLobe, foot
    
    func description() -> String {
        switch self {
            case .other: return "Other"
            case .chest: return "Chest"
            case .finger: return "Finger"
            case .wrist: return "Wrist"
            case .hand: return "Hand"
            case .earLobe: return "Ear lobe"
            case .foot: return "Foot"
        }
    }
}

class HeartRateSensor : NSObject, CBPeripheralDelegate, Sensor {

    weak var _peripheral : CBPeripheral!

    let type : SensorType = SensorType.heartRate
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
    var identifier: UUID {
        get {
            return _peripheral.identifier
        }
    }
    var location : HeartRateSensorLocation = .other
    
    class func readHeartRate(_ data : Data) -> UInt16 {
        
        var buffer = [UInt8](repeating: 0x00, count: data.count)
        (data as NSData).getBytes(&buffer, length: buffer.count)
        
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
    
    class func readHeartRateLocation(_ data: Data) -> HeartRateSensorLocation {
        
        var buffer = HeartRateSensorLocation.other
        
        (data as NSData).getBytes(&buffer, length:data.count)
        
        return buffer
    }
    
    init(peripheral : CBPeripheral) {
 
        super.init()

        _peripheral = peripheral
        _peripheral.delegate = self

        
     }
    
    var updateHeartRate : ((UInt16) -> Void)?
    
    /* These 2 should never get called because of how I'm fucking with the delegate */
    func peripheral(_ peripheral: CBPeripheral, didDiscoverIncludedServicesFor service: CBService, error: Error?) {
        
        NSLog("HRSensor: Found \(peripheral.name): service: \(service.description)")
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        NSLog("HRSensor didDiscoverServices")
        
        for service in peripheral.services! {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        if (service.uuid == CBUUID(string: kBTHR)) {
            NSLog("didDiscoverCharacteristics: \(peripheral.name), Service: \(service.uuid):\(service.uuid.uuidString), " + service.description)
            
            
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

    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {

        if let _ = error {
            NSLog("error")
        } else {
            switch characteristic.uuid.uuidString {
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
