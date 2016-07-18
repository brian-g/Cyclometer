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
        let anObject = super.popViewControllerAnimated(animated)

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

    private let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
        let managedContext = appDelegate.managedObjectContext!
        let fetchRequest = NSFetchRequest(entityName: "Ride")
        let sortDescriptor = NSSortDescriptor(key:"date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.fetchBatchSize = 20 // Optmize later
             
        do {
            let fetchResults = try managedContext.executeFetchRequest(fetchRequest) as? [Ride]
            
            NSLog("Number of rides: \(fetchResults!.count)")
            rides = fetchResults!
            
            if fetchResults!.count < 20 {
                
                let alert = UIAlertController(title: "Load demo data", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
                
                alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { ( action: UIAlertAction ) in
                    createDemoData(self.appDelegate.managedObjectContext!)
                }))
                
                alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Cancel, handler: nil))
                
                self.presentViewController(alert, animated: true, completion: nil)
            }

        } catch {
            NSLog("Could not fetch \(error), \(error)")
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
        
        var cell = tableView.dequeueReusableCellWithIdentifier("historyCell") 
        if cell === nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "historyCell")
        }

        let rideDate = rides[indexPath.row].date as NSDate
        let c = rides[indexPath.row].biometrics.count
        
        NSLog("Count of bio data \(c)")
        cell?.textLabel?.text = appDelegate.dateFormatter.stringFromDate(rideDate)
        
        return cell!
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        NSLog("prepareForSegue")
        
        let selectedRow = tableView.indexPathForSelectedRow
        let row = selectedRow?.row
        
        if (row != nil) {
//            (segue.destinationViewController as CylViewControllerParameter).viewControllerParameter = CylParameter(param: rides[row!], function:nil)
            (segue.destinationViewController as! CylRideDetailsController).ride = rides[row!]
        }
        
    }
    
}

class CylRideDetailsController : UIViewController, CylViewControllerParameter {

    let emptyString = "--"
    
    @IBOutlet weak var distance: CylNumberCardView!
    @IBOutlet weak var duration: CylNumberCardView!
    @IBOutlet weak var avgSpeed: CylNumberCardView!
    @IBOutlet weak var maxSpeed: CylNumberCardView!
    @IBOutlet weak var avgPace: CylNumberCardView!
    @IBOutlet weak var maxPace: CylNumberCardView!
    @IBOutlet weak var avgCadence: CylNumberCardView!
    @IBOutlet weak var maxCadence: CylNumberCardView!
    @IBOutlet weak var ascent: CylNumberCardView!
    @IBOutlet weak var descent: CylNumberCardView!
    @IBOutlet weak var avgHr: CylNumberCardView!
    @IBOutlet weak var maxHr: CylNumberCardView!

    
    var viewControllerParameter : CylParameter?
    var ride : Ride?
    
    let numberFormatter = NSNumberFormatter()
    
    private let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        numberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        
        self.navigationItem.title = appDelegate.dateFormatter.stringFromDate(ride!.date)
     
        updateValues()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

  
    func updateValues() {
        
        if let n = numberFormatter.stringFromNumber(ride!.summary.distance) {
            distance.number = n
        } else {
            distance.number = emptyString
        }

        if let n = numberFormatter.stringFromNumber(NSNumber(longLong:ride!.summary.time_active)) {
            duration.number = n
        } else {
            duration.number = emptyString
        }

        if let n = numberFormatter.stringFromNumber(ride!.summary.speed_avg) {
            avgSpeed.number = n
        } else {
            avgSpeed.number = emptyString
        }

        if let n = numberFormatter.stringFromNumber(ride!.summary.speed_max) {
            maxSpeed.number = n
        } else {
            maxSpeed.number = emptyString
        }

        if let n = numberFormatter.stringFromNumber(NSNumber(int: ride!.summary.elevation_gain)) {
            ascent.number = n
        } else {
            ascent.number = emptyString
        }

        if let n = numberFormatter.stringFromNumber(NSNumber(int: ride!.summary.elevation_loss)) {
            descent.number = n
        } else {
            descent.number = emptyString
        }

        if let n = numberFormatter.stringFromNumber(NSNumber(float: ride!.summary.pace_avg)) {
            avgPace.number = n
        } else {
            avgPace.number = emptyString
        }

        if let n = numberFormatter.stringFromNumber(NSNumber(float: ride!.summary.pace_max)) {
            maxPace.number = n
        } else {
            maxPace.number = emptyString
        }

        if let n = numberFormatter.stringFromNumber(NSNumber(float: ride!.summary.cadence_avg)) {
            avgCadence.number = n
        } else {
            avgCadence.number = emptyString
        }

        if let n = numberFormatter.stringFromNumber(NSNumber(short: ride!.summary.cadence_max)) {
            maxCadence.number = n
        } else {
            maxCadence.number = emptyString
        }

        if let n = numberFormatter.stringFromNumber(NSNumber(float: ride!.summary.hr_avg)) {
            avgHr.number = n
        } else {
            avgHr.number = emptyString
        }

        if let n = numberFormatter.stringFromNumber(NSNumber(short:ride!.summary.hr_max)) {
            maxHr.number = n
        } else {
            maxHr.number = emptyString
        }

    
    }
}


