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
    var identifier : UUID
    var type: SensorType
}

class DefaultsSensorInfo: NSObject {
    var name : NSString
    var capabilities : NSString
    var identifier: UUID
    var type: SensorType
    
    init(name : NSString, capabilities : NSString, identifier: UUID, type: SensorType) {
        self.name = name
        self.capabilities = capabilities
        self.identifier = identifier
        self.type = type
    }
}

enum SensorType : Int {
    case heartRate = 0
    case wheelAndCrankRPM
    
    func description() -> String {
        switch self {
            case .heartRate: return "Heart rate"
            case .wheelAndCrankRPM: return "Cadence and Wheel Speed"
        }
    }
    
}

protocol SensorManagerSensorListUpdates : class {
    func sensorManagerSensorListDidChange() -> Void
}

protocol SensorManagerHeartRateUpdates : class {
    func sensorManagerHearRateUpdated(_ bpm: UInt16) -> Void
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
    var identifier: UUID {
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

    private var _savedDevices = [Any]()
    private var _peripherals = [Sensor]()
    private var _disoveredPeripherals = [UUID: CBPeripheral]()
    private var _scanOnlyRemembered : Bool = true
    
    var updateHeartRate : ((UInt16) -> Void)?
    var updateWheelRevolutions : ((UInt32) -> Void)?
    var updateCrankRevolutions : ((UInt16) -> Void)?

    let services = [CBUUID(string: kBTHR), CBUUID(string: kBTCSC)]

    var isScanning : Bool = false

    
    override init() {
        
        super.init()
        
        _btManager = CBCentralManager(delegate: self, queue: nil)
        
        _savedDevices = UserDefaults.standard.array(forKey: kDevices)!
    }
    
    deinit {
        stopScanningForSensors()
    }

    
    func sensorCount() -> Int {
        return _peripherals.count
    }
    
    func sensorAt(_ index : Int) -> SensorInfo {

        let p = _peripherals[index]
        let info = SensorInfo(name: p.name,
                            capabilities: p.description,
                            remembered:p.remembered,
                            connected: p.connected,
                            identifier: p.identifier,
                            type: p.type)

        return info
    }
    
    func rememberSensor(_ p : UUID, remember : Bool) {
        for device in _peripherals {

            if device.identifier == p {
                if remember {
                    // TODO: Need to rip through remembered array and forgot shit that we're replacing
                    let db = DefaultsSensorInfo(name: device.name as NSString,
                                                capabilities: device.description as NSString,
                                                identifier: device.identifier,
                                                type: device.type)
                    _savedDevices.append(db)
                    UserDefaults.standard.synchronize()
                    
                } else {
                    
                }
            }
        }
    }
    
    func startScanningForSensors(_ scanOnlyRemembered: Bool = true) {
        _scanOnlyRemembered = scanOnlyRemembered
        
        
        if _btManager.state == CBManagerState.poweredOn && isScanning == false {
            NSLog("Started scanning...")
            _btManager.scanForPeripherals(withServices: services, options: nil)
            isScanning = true
        }
    }
    
    func stopScanningForSensors() {
        NSLog("Stopping scanning")
        _btManager.stopScan()
        isScanning = false
    }
    
    // Check status of BLE hardware
    func centralManagerDidUpdateState(_ central: CBCentralManager) {

        if central.state == CBManagerState.poweredOn {
            NSLog("Powered on")
            startScanningForSensors()
        }
        else if central.state == CBManagerState.poweredOff {
            // Can have different conditions for all states if needed - show generic alert for now
            NSLog("BLE Powered Off")
            central.stopScan();
        }
        else {
            NSLog("BLE Manager Did Update Unknown State")
        }
    }
    
    // Check out the discovered peripherals to find Sensor Tag
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        NSLog("Found peripheral: \(peripheral.name) \(RSSI)")
        _disoveredPeripherals[peripheral.identifier] = peripheral // Need to hold a strong reference
        if (_scanOnlyRemembered) {
            
        } else {
            
        }
        central.connect(peripheral, options: nil)
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        NSLog("Did fail \(peripheral.name): \(error!.localizedDescription)")
    }
    
    // Discover services of the peripheral
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {

        NSLog("Connected: \(peripheral.name), UUID: \(peripheral.identifier)")

        peripheral.delegate = self;
        peripheral.discoverServices(services)

    }
    
    func centralManager(_ central: CBCentralManager!, didRetrieveConnectedPeripherals peripherals: [AnyObject]!) {
        NSLog("Found connected shit")
        
    }
    // If disconnected, start searching again
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        
        NSLog("Disconnected " + peripheral.name!)
        
        _disoveredPeripherals[peripheral.identifier] = nil
        
        for i in 0 ..< _peripherals.count {
            if _peripherals[i].identifier == peripheral.identifier {
                _peripherals.remove(at: i)
                sensorListUpdatedDelegate?.sensorManagerSensorListDidChange()
            }
        }

    }

    /* Periphal delegates */
    func peripheral(_ peripheral: CBPeripheral, didDiscoverIncludedServicesFor service: CBService, error: Error?) {

        NSLog("Found one Name \(peripheral.name): service: \(service.description)")

    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        NSLog("didDiscoverServices")
        
        for service in peripheral.services! {
            if service.uuid == CBUUID(string: kBTHR) {
                let _heartRate = HeartRateSensor(peripheral: service.peripheral)
                _heartRate.connected = true
                _peripherals.append(_heartRate)
                // TODO: Cleanup _discoveredPeripherals
                
                if updateHeartRate != nil {
                    _heartRate.updateHeartRate = updateHeartRate
                }
            } else if service.uuid == CBUUID(string: kBTCSC) {
                let _cycling = CycleSensor(peripheral: service.peripheral)
                _peripherals.append(_cycling)
                
                if updateWheelRevolutions != nil {
                    _cycling.updateWheelRevolutions = updateWheelRevolutions
                }
            }
            peripheral.discoverCharacteristics(nil, for: service)
        }
        sensorListUpdatedDelegate?.sensorManagerSensorListDidChange()
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {

        NSLog("DEAD")
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        NSLog("DEAD")
    }
}
