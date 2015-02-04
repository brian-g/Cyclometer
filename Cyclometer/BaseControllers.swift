//
//  ViewController.swift
//  Cyclometer
//
//  Created by Brian on 12/31/14.
//  Copyright (c) 2014 Brian Glaeske. All rights reserved.
//

import UIKit
import CoreData

class CylNavigationController : UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.tintColor = UIColor(red:0.0, green:0.415, blue:0.431, alpha:1.0)
        self.navigationBar.barTintColor = UIColor(red:1.0, green:0.89, blue:0.639, alpha:1)
        
        self.setNavigationBarHidden(true, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func pushViewController(viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        
        self.setNavigationBarHidden(false, animated: animated)

    }

    override func popViewControllerAnimated(animated: Bool) -> UIViewController? {
        var anObject = super.popViewControllerAnimated(animated)

        if self.childViewControllers.count == 1 {

            self.setNavigationBarHidden(true, animated: animated)
        }
        
        return anObject
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        NSLog(segue.identifier!);
    }
}

class CylHistoryController : UITableViewController {

    var rides = [Ride]()

    private let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
        let managedContext = appDelegate.managedObjectContext!
        let fetchRequest = NSFetchRequest(entityName: "Ride")
        
        var error: NSError?
        
        if let fetchResults = managedContext.executeFetchRequest(fetchRequest, error: &error) as? [Ride] {
            
            NSLog("Number of rides: \(fetchResults.count)")
            rides = fetchResults
            
            if fetchResults.count < 20 {
                
                let alert = UIAlertController(title: "Load demo data", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
                
                alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { ( action: UIAlertAction? ) in
                    self.createDemoData()
                }))
                
                alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Cancel, handler: nil))
                
                self.presentViewController(alert, animated: true, completion: nil)
            }
        } else {
            NSLog("Could not fetch \(error), \(error!.userInfo)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rides.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        NSLog("cellForRowAtIndexPath: \(indexPath.row)")
        
        var cell = tableView.dequeueReusableCellWithIdentifier("historyCell") as UITableViewCell?
        if cell === nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "historyCell")
        }

        var rideDate = rides[indexPath.row].date as NSDate
        var c = rides[indexPath.row].biometrics.count
        
        NSLog("Count of bio data \(c)")
        cell?.textLabel?.text = appDelegate.dateFormatter.stringFromDate(rideDate)
        
        return cell!
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        NSLog("prepareForSegue")
        
        var selectedRow = tableView.indexPathForSelectedRow()
        var row = selectedRow?.row
        
        if (row != nil) {
//            (segue.destinationViewController as CylViewControllerParameter).viewControllerParameter = CylParameter(param: rides[row!], function:nil)
            (segue.destinationViewController as CylRideDetailsController).ride = rides[row!]
        }
        
    }

    func createDemoData() {
        let managedContext = appDelegate.managedObjectContext!
        
        var ride = NSEntityDescription.insertNewObjectForEntityForName("Ride", inManagedObjectContext: managedContext) as Ride
        var summary = NSEntityDescription.insertNewObjectForEntityForName("Summary", inManagedObjectContext: managedContext) as Summary

        summary.elevation_gain = 500
        summary.elevation_loss = 301
        summary.distance = 30
        summary.speed_avg = 15.5
        summary.speed_max = 32.9
        summary.hr_avg = 78
        summary.hr_max = 130
        summary.pace_avg = 10
        summary.pace_avg = 1.9
        summary.pace_max = 2.3
        summary.pace_min = 1.0
        summary.cadence_avg = 80
        summary.cadence_max = 130
        summary.start = NSDate()
        summary.end = NSDate(timeIntervalSinceNow: 10800.0)
        summary.time_active = 10353
        summary.time_total = 10800
        
        ride.date = NSDate()
        ride.summary = summary
        
        summary.ride = ride
        
        var biometrics = [Biometrics]()

        for i in 1...15 {
            var bio = NSEntityDescription.insertNewObjectForEntityForName("Biometrics", inManagedObjectContext: managedContext) as Biometrics
            bio.date = NSDate(timeIntervalSinceNow: 5)
            bio.ride = ride
            bio.bpm = 78
        }

        var motion = [Motion]()
        
        for i in 1...20 {
            var motion = NSEntityDescription.insertNewObjectForEntityForName("Motion", inManagedObjectContext: managedContext) as Motion
            
            motion.date = NSDate()
            motion.cadence = 78
            motion.gpsspeed = 15.6
            motion.wheelspeed = 15.5
            motion.ride = ride
            
        }
        
        
        var error: NSError?
        if !managedContext.save(&error) {
            NSLog("Could not save \(error), \(error?.userInfo)")
        }

    }
    
}

class CylRideDetailsController : UIViewController, CylViewControllerParameter {

    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var avgSpeedLabel: UILabel!
    @IBOutlet weak var maxSpeedLabel: UILabel!
    @IBOutlet weak var avgPaceLabel: UILabel!
    @IBOutlet weak var maxPaceLabel: UILabel!
    @IBOutlet weak var acentLabel: UILabel!
    @IBOutlet weak var decentLabel: UILabel!
    
    var viewControllerParameter : CylParameter?
    
    var ride : Ride?
    
    private let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = appDelegate.dateFormatter.stringFromDate(ride!.date)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


class CylSettingsController : UITableViewController {
    
    let deviceSection = 1
    let maxDevices = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
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
            return 3
        }
        return super.tableView(tableView, numberOfRowsInSection:section)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == deviceSection {
            
            var cell : CylSettingsDeviceInfoCell? = tableView.dequeueReusableCellWithIdentifier("deviceInfoCell") as? CylSettingsDeviceInfoCell
            
            if cell === nil {
                cell = (NSBundle.mainBundle().loadNibNamed("CylSettingsDeviceInfoCell", owner: nil, options: nil)[0] as CylSettingsDeviceInfoCell)
                
                cell?.deviceName?.text = "Device \(indexPath.row)"
                cell?.deviceCapabilities?.text = "Heart rate, Location"
                cell?.isConnected?.highlighted = true
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
