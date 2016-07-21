//
//  SettingsControllers.swift
//  Cyclometer
//
//  Created by brian on 4/6/15.
//  Copyright (c) 2015 Brian Glaeske. All rights reserved.
//

import UIKit
import Foundation


let kAutoPause = "AutoPause"
let kUseInBackground = "UseInBackground"
let kAutoDim = "AutoDim"
let kUnits = "Units"
let kWheelSize = "Wheelsize"
let kDevices = "Devices"
let kSensorName = "SensorName"
let kSensorId = "SensorID"
let kSensorCap = "SensorCap"


enum Units : Int {
    case imperial = 0
    case metric = 1
    
    func description() -> String {
        switch self {
        case .imperial:
            return "Miles"
        case .metric:
            return "Metric"
        }
    }
}

var currentUnits = Units.imperial


class CylSettingsController : UITableViewController, SensorManagerSensorListUpdates {
    
    let deviceSection = 1
    let maxDevices = 10
    var defaults = UserDefaults.standard
    private let sensorManager = SensorManager.sharedManager
    
    @IBOutlet weak var autoPause: UISwitch!
    @IBOutlet weak var trackInBackground: UISwitch!
    @IBOutlet weak var units: UISegmentedControl!
    @IBOutlet weak var autoDim: UISwitch!
    @IBOutlet weak var wheelSize: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        updateControlsFromDefaults()
        sensorManager.sensorListUpdatedDelegate = self
        sensorManager.startScanningForSensors()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        NSLog(segue.identifier!)
        
        if segue.identifier == "wheelSizePicker" {
            
        }
    }
    
    func updateControlsFromDefaults() {
        
        autoPause.isOn = defaults.bool(forKey: kAutoPause)
        trackInBackground.isOn = defaults.bool(forKey: kUseInBackground)
        units.selectedSegmentIndex = defaults.integer(forKey: kUnits)
        autoDim.isOn = defaults.bool(forKey: kAutoDim)
        
        let size = defaults.integer(forKey: kWheelSize)
        if (size <= 0) {
            wheelSize.text = "Automatic"
        } else {
            
        }
    }
    
    func rememberToggled(_ sender : CylSettingsDeviceInfoCell) {
        NSLog("rememberToggled")
        
        sensorManager.rememberSensor(sender.peripheral.identifier, remember: sender.isRemembered.isOn)
    }
    
    @IBAction func updateDefaultsFromControls(_ sender: AnyObject) {
        
        defaults.set(autoPause.isOn, forKey: kAutoPause)
        defaults.set(trackInBackground.isOn, forKey: kUseInBackground)
        defaults.set(autoDim.isOn, forKey: kAutoDim)
        defaults.set(units.selectedSegmentIndex, forKey: kUnits)
        
    }
    
    func sensorManagerSensorListDidChange() {
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return super.numberOfSections(in: tableView)
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if (indexPath as NSIndexPath).section == deviceSection {
            return 44.0
        }
        
        return super.tableView(tableView, heightForRowAt:indexPath)
    }
    
    override func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        
        if (indexPath as NSIndexPath).section == deviceSection {
            return 0
        }
        
        return super.tableView(tableView, indentationLevelForRowAt:indexPath)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == deviceSection {
            return sensorManager.sensorCount();
        }
        return super.tableView(tableView, numberOfRowsInSection:section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath as NSIndexPath).section == deviceSection {
            
            var cell : CylSettingsDeviceInfoCell? = tableView.dequeueReusableCell(withIdentifier: "deviceInfoCell") as? CylSettingsDeviceInfoCell
            
            if cell === nil {
                cell = (Bundle.main.loadNibNamed("CylSettingsDeviceInfoCell", owner: nil, options: nil)[0] as! CylSettingsDeviceInfoCell)
                
                let sensor = sensorManager.sensorAt((indexPath as NSIndexPath).row)
                
                cell?.deviceName?.text = sensor.name
                cell?.deviceCapabilities?.text = sensor.capabilities
                cell?.isConnected?.isHighlighted = sensor.connected
                cell?.isRemembered?.isOn = sensor.remembered
                cell?.peripheral = sensor
                cell?.isRemembered.addTarget(self, action: #selector(CylSettingsController.rememberToggled(_:)), for: UIControlEvents.valueChanged)
            }
            return cell!
        }
        
        return super.tableView(tableView, cellForRowAt: indexPath)
    }
    
    @IBAction func unwindFromWheelPicker(_ segue: UIStoryboardSegue) {
        NSLog("unwindFromWheelPicker")
        segue.sourceViewController.dismiss(animated: true, completion: nil)
    }
}

class CylWheelPickerViewController : UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let sizes = [
        "Automatic",
        "700c x 20",
        "700c x 23",
        "700c x 25",
        "700c x 28",
        "700c x 32",
        "700c x 35",
        "700c x 38",
        "700c x 44",
        "700c x 50",
        "700c x 56",
        "26 x 1.0",
        "26 x 1.25",
        "26 x 1.5",
        "26 x 1.9",
        "26 x 2.125",
        "27 x 1",
        "27 x 1 1/8",
        "27 x 1 1/4",
        "27 x 1 3/8",
        "29 x 1",
        "29 x 1.25",
        "29 x 1.5"
    ]
    
    @IBOutlet weak var picker: UIPickerView!
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sizes[row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sizes.count
    }
    
}
