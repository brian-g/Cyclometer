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
let kUseHealthKit = "HealthKit"
let kUnits = "Units"
let kWheelSize = "Wheelsize"
let kDevices = "Devices"
let kSensorName = "SensorName"
let kSensorId = "SensorID"
let kSensorCap = "SensorCap"


enum Units : Int {
    case Imperial = 0
    case Metric = 1
    
    func description() -> String {
        switch self {
        case .Imperial:
            return "Miles"
        case .Metric:
            return "Metric"
        }
    }
}

var currentUnits = Units.Imperial


class CylSettingsController : UITableViewController, SensorManagerSensorListUpdates {
    
    let deviceSection = 1
    let maxDevices = 10
    var defaults = NSUserDefaults.standardUserDefaults()
    private let sensorManager = SensorManager.sharedManager
    
    @IBOutlet weak var autoPause: UISwitch!
    @IBOutlet weak var trackInBackground: UISwitch!
    @IBOutlet weak var units: UISegmentedControl!
    @IBOutlet weak var useHealthKit: UISwitch!
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
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        NSLog(segue.identifier!)
        
        if segue.identifier == "wheelSizePicker" {
            
        }
    }
    
    func updateControlsFromDefaults() {
        
        autoPause.on = defaults.boolForKey(kAutoPause)
        trackInBackground.on = defaults.boolForKey(kUseInBackground)
        units.selectedSegmentIndex = defaults.integerForKey(kUnits)
        useHealthKit.on = defaults.boolForKey(kUseHealthKit)
        
        let size = defaults.integerForKey(kWheelSize)
        if (size <= 0) {
            wheelSize.text = "Automatic"
        } else {
            
        }
    }
    
    func rememberToggled(sender : CylSettingsDeviceInfoCell) {
        NSLog("rememberToggled")
        
//        sensorManager.rememberSensor(sender.peripheral, remember: sender.isRemembered.on)
    }
    
    @IBAction func updateDefaultsFromControls(sender: AnyObject) {
        
        defaults.setBool(autoPause.on, forKey: kAutoPause)
        defaults.setBool(trackInBackground.on, forKey: kUseInBackground)
        defaults.setBool(useHealthKit.on, forKey: kUseHealthKit)
        defaults.setInteger(units.selectedSegmentIndex, forKey: kUnits)
        
    }
    
    func sensorManagerSensorListDidChange() {
        tableView.reloadData()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return super.numberOfSectionsInTableView(tableView)
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.section == deviceSection {
            return 44.0
        }
        
        return super.tableView(tableView, heightForRowAtIndexPath:indexPath)
    }
    
    override func tableView(tableView: UITableView, indentationLevelForRowAtIndexPath indexPath: NSIndexPath) -> Int {
        
        if indexPath.section == deviceSection {
            return 0
        }
        
        return super.tableView(tableView, indentationLevelForRowAtIndexPath:indexPath)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == deviceSection {
            return sensorManager.sensorCount();
        }
        return super.tableView(tableView, numberOfRowsInSection:section)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == deviceSection {
            
            var cell : CylSettingsDeviceInfoCell? = tableView.dequeueReusableCellWithIdentifier("deviceInfoCell") as? CylSettingsDeviceInfoCell
            
            if cell === nil {
                cell = (NSBundle.mainBundle().loadNibNamed("CylSettingsDeviceInfoCell", owner: nil, options: nil)[0] as! CylSettingsDeviceInfoCell)
                
                let sensor = sensorManager.sensorAt(indexPath.row)
                
                cell?.deviceName?.text = sensor.name
                cell?.deviceCapabilities?.text = sensor.capabilities
                cell?.isConnected?.highlighted = sensor.connected
                cell?.isRemembered?.on = sensor.remembered
                cell?.peripheral = sensor.peripheral
                cell?.isRemembered.addTarget(self, action: "rememberToggled:", forControlEvents: UIControlEvents.ValueChanged)
            }
            return cell!
        }
        
        return super.tableView(tableView, cellForRowAtIndexPath: indexPath)
    }
    
    @IBAction func unwindFromWheelPicker(segue: UIStoryboardSegue) {
        NSLog("unwindFromWheelPicker")
        segue.sourceViewController.dismissViewControllerAnimated(true, completion: nil)
        //        (segue.destinationViewController as CylHistoryController).wheelSize =
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
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return sizes[row]
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sizes.count
    }
    
}
