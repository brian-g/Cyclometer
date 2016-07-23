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

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        
        self.setNavigationBarHidden(false, animated: animated)

    }

    override func popViewController(animated: Bool) -> UIViewController? {
        let anObject = super.popViewController(animated: animated)

        if self.childViewControllers.count == 1 {

            self.setNavigationBarHidden(true, animated: animated)
        }
        
        return anObject
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        NSLog(segue.identifier!);
    }
}

class CylHistoryController : UITableViewController {

    var rides = [Ride]()
    var rowActions = [UITableViewRowAction]()
    
    private let appDelegate = UIApplication.shared().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
        let managedContext = appDelegate.managedObjectContext!
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Ride")
        let sortDescriptor = SortDescriptor(key:"date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.fetchBatchSize = 20 // Optmize later
             
        do {
            let fetchResults = try managedContext.fetch(fetchRequest) as? [Ride]
            
            NSLog("Number of rides: \(fetchResults!.count)")
            rides = fetchResults!
            
            if fetchResults!.count < 20 {
                
                let alert = UIAlertController(title: "Load demo data", message: nil, preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { ( action: UIAlertAction ) in
                    createDemoData(self.appDelegate.managedObjectContext!)
                }))
                
                alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
            }

        } catch {
            NSLog("Could not fetch \(error), \(error)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rides.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        NSLog("cellForRowAtIndexPath: \((indexPath as NSIndexPath).row)")
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "historyCell") 
        if cell === nil {
            cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "historyCell")
        }

        let rideDate = rides[(indexPath as NSIndexPath).row].date as Date
        let c = rides[(indexPath as NSIndexPath).row].biometrics.count
        
        NSLog("Count of bio data \(c)")
        cell?.textLabel?.text = appDelegate.dateFormatter.string(from: rideDate)
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if (rowActions.count > 0) { return rowActions }
        
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Delete", handler: doDeleteRow)
        rowActions.append(deleteAction)
        
        return rowActions
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        NSLog("prepareForSegue")
        
        let selectedRow = tableView.indexPathForSelectedRow
        let row = (selectedRow as NSIndexPath?)?.row
        
        if (row != nil) {
//            (segue.destinationViewController as CylViewControllerParameter).viewControllerParameter = CylParameter(param: rides[row!], function:nil)
            (segue.destinationViewController as! CylRideDetailsController).ride = rides[row!]
        }
        
    }

    func doDeleteRow(action: UITableViewRowAction, rowIndex: IndexPath) {
        print ("Delete row called for \(rowIndex)")
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
    
    let numberFormatter = NumberFormatter()
    
    private let appDelegate = UIApplication.shared().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        
        self.navigationItem.title = appDelegate.dateFormatter.string(from: ride!.date)
     
        updateValues()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

  
    func updateValues() {
        
        if let n = numberFormatter.string(from: ride!.summary.distance) {
            distance.number = n
        } else {
            distance.number = emptyString
        }

        if let n = numberFormatter.string(from: NSNumber(value:ride!.summary.time_active)) {
            duration.number = n
        } else {
            duration.number = emptyString
        }

        if let n = numberFormatter.string(from: ride!.summary.speed_avg) {
            avgSpeed.number = n
        } else {
            avgSpeed.number = emptyString
        }

        if let n = numberFormatter.string(from: ride!.summary.speed_max) {
            maxSpeed.number = n
        } else {
            maxSpeed.number = emptyString
        }

        if let n = numberFormatter.string(from: NSNumber(value: ride!.summary.elevation_gain)) {
            ascent.number = n
        } else {
            ascent.number = emptyString
        }

        if let n = numberFormatter.string(from: NSNumber(value: ride!.summary.elevation_loss)) {
            descent.number = n
        } else {
            descent.number = emptyString
        }

        if let n = numberFormatter.string(from: NSNumber(value: ride!.summary.pace_avg)) {
            avgPace.number = n
        } else {
            avgPace.number = emptyString
        }

        if let n = numberFormatter.string(from: NSNumber(value: ride!.summary.pace_max)) {
            maxPace.number = n
        } else {
            maxPace.number = emptyString
        }

        if let n = numberFormatter.string(from: NSNumber(value: ride!.summary.cadence_avg)) {
            avgCadence.number = n
        } else {
            avgCadence.number = emptyString
        }

        if let n = numberFormatter.string(from: NSNumber(value: ride!.summary.cadence_max)) {
            maxCadence.number = n
        } else {
            maxCadence.number = emptyString
        }

        if let n = numberFormatter.string(from: NSNumber(value: ride!.summary.hr_avg)) {
            avgHr.number = n
        } else {
            avgHr.number = emptyString
        }

        if let n = numberFormatter.string(from: NSNumber(value:ride!.summary.hr_max)) {
            maxHr.number = n
        } else {
            maxHr.number = emptyString
        }

    
    }
}


