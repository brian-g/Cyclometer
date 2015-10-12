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

let scanningTimeout = 120.0

struct SensorInfo {
    var name : String
    var capabilities : String
    var remembered : Bool
    var connected : Bool
    var peripheral : NSUUID
    var type: SensorType
}

class DefaultsSensorInfo: NSObject {
    var name : NSString
    var capabilities : NSString
    var identifier: NSUUID
    var type: SensorType
    
    init(name : NSString, capabilities : NSString, identifier: NSUUID, type: SensorType) {
        self.name = name
        self.capabilities = capabilities
        self.identifier = identifier
        self.type = type
    }
}

enum SensorType : Int {
    case HeartRate = 0
    case WheelAndCrankRPM
    
    func description() -> String {
        switch self {
            case .HeartRate: return "Heart rate"
            case .WheelAndCrankRPM: return "Cadence and Wheel Speed"
        }
    }
    
}

protocol SensorManagerSensorListUpdates : class {
    func sensorManagerSensorListDidChange() -> Void
}

protocol SensorManagerHeartRateUpdates : class {
    func sensorManagerHearRateUpdated(bpm: UInt16) -> Void
}

protocol Sensor : class {
    var type: SensorType {
        get
    }
    var name: String {
        get
    }
    var connected: Bool {
        get
    }
    var remembered: Bool {
        get
    }
    var description: String {
        get
    }
    var identifier: NSUUID {
        get
    }
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
    private var _peripherals = [Sensor]()
    private var _disoveredPeripherals = [NSUUID: CBPeripheral]()
    
    var updateHeartRate : ((UInt16) -> Void)?
    var updateWheelRevolutions : ((UInt32) -> Void)?
    var updateCrankRevolutions : ((UInt16) -> Void)?

    let services = [CBUUID(string: kBTHR), CBUUID(string: kBTCSC)]

    var isScanning : Bool = false
    
    override init() {
        
        super.init()
        
        _btManager = CBCentralManager(delegate: self, queue: nil)
        
        _savedDevices = NSUserDefaults.standardUserDefaults().arrayForKey(kDevices)!

    }
    
    deinit {
        stopScanningForSensors()
    }

    
    func sensorCount() -> Int {
        return _peripherals.count
    }
    
    func sensorAt(index : Int) -> SensorInfo {

        let p = _peripherals[index]
        let info = SensorInfo(name: p.name,
                            capabilities: p.description,
                            remembered:p.remembered,
                            connected: p.connected,
                            peripheral: p.identifier,
                            type: p.type)

        return info
    }
    
    func rememberSensor(p : NSUUID, remember : Bool) {
        for device in _peripherals {
            if device.identifier == p {
                if remember {
                    // TODO: Need to rip through remembered array and forgot shit that we're replacing
                    let db = DefaultsSensorInfo(name: device.name,
                                                capabilities: device.description,
                                                identifier: device.identifier,
                                                type: device.type)
                    _savedDevices.append(db)
                    NSUserDefaults.standardUserDefaults().synchronize()
                    
                } else {
                    
                }
            }
        }
    }
    
    func startScanningForSensors() {
        
        if _btManager.state == CBCentralManagerState.PoweredOn {
            NSLog("Started scanning...")
            _btManager.scanForPeripheralsWithServices(services, options: nil)
            isScanning = true
            
            NSTimer.schedule(delay: scanningTimeout) { timer in
                self.stopScanningForSensors()
            }
        }
    }
    
    func stopScanningForSensors() {
        NSLog("Stopping scanning")
        _btManager.stopScan()
        isScanning = false
    }

    // Check status of BLE hardware
    func centralManagerDidUpdateState(central: CBCentralManager) {
        
        if central.state == CBCentralManagerState.PoweredOn {
            NSLog("Powered on")
            startScanningForSensors()
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
    func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {
        
        NSLog("Found peripheral: \(peripheral.name) \(RSSI)")

        _disoveredPeripherals[peripheral.identifier] = peripheral // Need to hold a strong reference
        central.connectPeripheral(peripheral, options: nil)
    }
    
    func centralManager(central: CBCentralManager, didFailToConnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        NSLog("Did fail \(peripheral.name): \(error!.description)")
    }
    
    // Discover services of the peripheral
    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {

        NSLog("Connected: \(peripheral.name), UUID: \(peripheral.identifier)")

        peripheral.delegate = self;
        peripheral.discoverServices(services)

    }
    
    func centralManager(central: CBCentralManager!, didRetrieveConnectedPeripherals peripherals: [AnyObject]!) {
        NSLog("Found connected shit")
        
    }
    // If disconnected, start searching again
    func centralManager(central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        
        NSLog("Disconnected " + peripheral.name!)
        
        _disoveredPeripherals[peripheral.identifier] = nil
        
        for var i = 0; i < _peripherals.count; i++ {
            if _peripherals[i].identifier == peripheral.identifier {
                _peripherals.removeAtIndex(i)
                sensorListUpdatedDelegate?.sensorManagerSensorListDidChange()
            }
        }

    }

    /* Periphal delegates */
    func peripheral(peripheral: CBPeripheral, didDiscoverIncludedServicesForService service: CBService, error: NSError?) {

        NSLog("Found one Name \(peripheral.name): service: \(service.description)")

    }
    
    func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
        NSLog("didDiscoverServices")
        
        for service in peripheral.services! {
            if service.UUID == CBUUID(string: kBTHR) {
                let _heartRate = HeartRateSensor(peripheral: service.peripheral)
                _heartRate.connected = true
                _peripherals.append(_heartRate)
                // TODO: Cleanup _discoveredPeripherals
                
                if updateHeartRate != nil {
                    _heartRate.updateHeartRate = updateHeartRate
                }
            } else if service.UUID == CBUUID(string: kBTCSC) {
                let _cycling = CycleSensor(peripheral: service.peripheral)
                _peripherals.append(_cycling)
                
                if updateWheelRevolutions != nil {
                    _cycling.updateWheelRevolutions = updateWheelRevolutions
                }
            }
            peripheral.discoverCharacteristics(nil, forService: service)
        }
        sensorListUpdatedDelegate?.sensorManagerSensorListDidChange()
    }
    
    func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?) {

        NSLog("DEAD")
    }
    
    func peripheral(peripheral: CBPeripheral, didUpdateValueForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        
        NSLog("DEAD")
    }
}