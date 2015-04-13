//
//  SensorManager.swift
//  Cyclometer
//
//  Created by brian on 4/3/15.
//  Copyright (c) 2015 Brian Glaeske. All rights reserved.
//

import Foundation
import CoreBluetooth

let kBTCSC = "1816"
let kBTCSCMeasurement = "2A5B"
let kBTCSCFeature = "2A5C"
let kBTCSCLocation = "2A5D"
let kBTHR = "180D"
let kBTHRMeasurement = "2A37"
let kBTHRLocation = "2A38"

struct SensorInfo {
    var name : String
    var capabilities : String
    var remembered : Bool
    var connected : Bool
    var peripheral : CBPeripheral?
}

struct DefaultsSensorInfo {
    var name : String
    var description: String
    var device: NSUUID
}

enum SensorType : Int {
    case HeartRate = 0
    case WheelRPM, CrankRPM
    
    func description() -> String {
        switch self {
            case .HeartRate: return "Heart rate"
            case .CrankRPM: return "Cadence"
            case .WheelRPM: return "Velocity"
        }
    }
    
}

protocol SensorManagerSensorListUpdates : class {
    func sensorManagerSensorListDidChange() -> Void
}

protocol SensorManagerHeartRateUpdates : class {
    
    func sensorManagerHearRateUpdated(bpm: UInt16) -> Void
    
}

class SensorManager : NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    class var sharedManager: SensorManager {
        struct Static {
            static let instance = SensorManager()
        }
        return Static.instance
    }

    weak var sensorListUpdatedDelegate : SensorManagerSensorListUpdates?
    
    private var _btManager : CBCentralManager!

    private var _savedDevices = [AnyObject]()
    private var _peripherals = [CBPeripheral]()
    
    private var _heartRate : HeartRateSensor!
    
    var updateHeartRate : ((UInt16) -> Void)?
    
    override init() {
        
        super.init()
        
        _btManager = CBCentralManager(delegate: self, queue: nil)
        
        _savedDevices = NSUserDefaults.standardUserDefaults().arrayForKey(kDevices)!

    }
    
    deinit {
        stopScanningForSensors()
    }

    func startScanningForSensors() {
        var services : [AnyObject] = [ CBUUID(string: kBTHR), CBUUID(string: kBTCSC)]
        
        let lastPeripherals = _btManager.retrieveConnectedPeripheralsWithServices(services)
        
        if lastPeripherals.count > 0{
            let device = lastPeripherals.last as! CBPeripheral;
            _btManager.connectPeripheral(device, options: nil)
        }
        else {
            _btManager.scanForPeripheralsWithServices(services, options: nil)
        }
        
        _btManager.scanForPeripheralsWithServices(services, options: nil)
    }
    
    func stopScanningForSensors() {
        _btManager.stopScan()
    }
    
    func sensorCount() -> Int {
        return _peripherals.count
    }
    
    func sensorAt(index : Int) -> SensorInfo {

        let peripheral = _peripherals[index]
        var info = SensorInfo(name: peripheral.name,
                            capabilities: peripheral.description,
                            remembered:false,
                            connected: false,
                            peripheral: peripheral)
        
        return info
    }
    
    // Check status of BLE hardware
    func centralManagerDidUpdateState(central: CBCentralManager!) {
        
        if central.state == CBCentralManagerState.PoweredOn {
            // Scan for peripherals if BLE is turned on
            var services : [AnyObject] = [ CBUUID(string: "180D"), CBUUID(string: "1816")]

            let lastPeripherals = central.retrieveConnectedPeripheralsWithServices(services)
            
            if lastPeripherals.count > 0{
                let device = lastPeripherals.last as! CBPeripheral;
                central.connectPeripheral(device, options: nil)
            }
            else {
                central.scanForPeripheralsWithServices(services, options: nil)
            }
            
            central.scanForPeripheralsWithServices(services, options: nil)
        }
        else if central.state == CBCentralManagerState.PoweredOff {
            // Can have different conditions for all states if needed - show generic alert for now
            NSLog("BLE Powered Off")
            central.stopScan();
        }
        else {
            NSLog("BLE Manager Did Update Unknown State")
        }
    }
    
    // Check out the discovered peripherals to find Sensor Tag
    func centralManager(central: CBCentralManager!, didDiscoverPeripheral peripheral: CBPeripheral!, advertisementData: [NSObject : AnyObject]!, RSSI: NSNumber!) {
        
        NSLog("Device:\(peripheral.name) RSSI: \(RSSI)")
        
        central.connectPeripheral(peripheral, options: nil)
        
        _peripherals.append(peripheral)
        peripheral.delegate = self
        
        // TODO: Fix this.
        var device = SensorInfo(name: peripheral.name, capabilities: "Something", remembered: false, connected: true, peripheral: peripheral)
        
        sensorListUpdatedDelegate?.sensorManagerSensorListDidChange()
        
    }
    
    // Discover services of the peripheral
    func centralManager(central: CBCentralManager!, didConnectPeripheral peripheral: CBPeripheral!) {

        NSLog("Connected: \(peripheral.name), UUID: \(peripheral.identifier)")
        
        var services = [CBUUID(string: kBTHR), CBUUID(string: kBTCSC)]

        peripheral.discoverServices(services)

    }
    
    // If disconnected, start searching again
    func centralManager(central: CBCentralManager!, didDisconnectPeripheral peripheral: CBPeripheral!, error: NSError!) {
        
        NSLog("Disconnected " + peripheral.name)

        sensorListUpdatedDelegate?.sensorManagerSensorListDidChange()
        
    }

    /* Periphal delegates */
    func peripheral(peripheral: CBPeripheral!, didDiscoverIncludedServicesForService service: CBService!, error: NSError!) {
        

        NSLog("Found one Name \(peripheral.name): service: \(service.description)")
        
    }
    
    func peripheral(peripheral: CBPeripheral!, didDiscoverServices error: NSError!) {
        NSLog("didDiscoverServices")
        
        for service in peripheral.services as! [CBService] {
            if service.UUID == CBUUID(string: kBTHR) {
                _heartRate = HeartRateSensor(peripheral: service.peripheral)
                if updateHeartRate != nil {
                    _heartRate.updateHeartRate = updateHeartRate
                }
            }
            peripheral.discoverCharacteristics(nil, forService: service)
        }
    }
    
    func peripheral(peripheral: CBPeripheral!, didDiscoverCharacteristicsForService service: CBService!, error: NSError!) {

        NSLog("DEAD")
    }
    
    func peripheral(peripheral: CBPeripheral!, didUpdateValueForCharacteristic characteristic: CBCharacteristic!, error: NSError!) {
        
        NSLog("DEAD")
    }
}