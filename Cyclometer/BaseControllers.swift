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

    let dateFormatter = NSDateFormatter()
    
    var rides = [NSManagedObject]()

    private let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
        dateFormatter.locale = NSLocale.currentLocale()
        dateFormatter.timeZone = NSTimeZone.systemTimeZone()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.doesRelativeDateFormatting = true
        
        let managedContext = appDelegate.managedObjectContext!
        let fetchRequest = NSFetchRequest(entityName: "Ride")
        var error: NSError?
        
        let fetchResults = managedContext.executeFetchRequest(fetchRequest, error: &error) as [NSManagedObject]?
        
        if let results = fetchResults {
            rides = results
            if rides.count < 10 {
                
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
        
        var cell = tableView.dequeueReusableCellWithIdentifier("historyCell") as UITableViewCell?


        if cell === nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "historyCell")
        }

        var rideDate = rides[indexPath.row].valueForKey("date") as NSDate
        
        cell?.textLabel?.text = dateFormatter.stringFromDate(rideDate)
        
        return cell!
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        NSLog("pre[pareForSegque")
        
        var selectedRow = tableView.indexPathForSelectedRow()
        var row = selectedRow?.row
        
        if (row != nil) {
            segue.destinationViewController.navigationItem.title = dateFormatter.stringFromDate((rides[row!].valueForKey("date") as NSDate))
        }
        
    }

    func createDemoData() {
        let managedContext = appDelegate.managedObjectContext!
        
        var entity = NSEntityDescription.entityForName("Ride", inManagedObjectContext: managedContext)
        
        let ride = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)

        ride.setValue(NSDate(), forKey: "date")

        var error: NSError?
        if !managedContext.save(&error) {
            NSLog("Could not save \(error), \(error?.userInfo)")
        }

    }
    
}

class CylSettingsController : UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
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
        NSLog(segue.identifier!);
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
    
    // MARK - PickerView Delegate
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if row == 1 {
            return "700c x 23"
        }
        
        return "Automatic"
    }
    
    // MARK - UIPickerViewDataSource
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }
    
}

