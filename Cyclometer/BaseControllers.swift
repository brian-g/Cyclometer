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
        
        self.navigationBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.navigationBar.barTintColor = globalTintColor
        
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

class CylRideDetailsController : UITableViewController {

    let emptyString = "--"
    let englishUnits = UserDefaults.standard.bool(forKey: kUnits)
    
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var avgSpeed: UILabel!
    @IBOutlet weak var maxSpeed: UILabel!
    @IBOutlet weak var avgPace: UILabel!
    @IBOutlet weak var maxPace: UILabel!
    @IBOutlet weak var avgCadence: UILabel!
    @IBOutlet weak var maxCadence: UILabel!
    @IBOutlet weak var ascent: UILabel!
    @IBOutlet weak var descent: UILabel!
    @IBOutlet weak var avgHr: UILabel!
    @IBOutlet weak var maxHr: UILabel!

    var ride : Ride?
    
    let numberFormatter = NumberFormatter()
    
    private let appDelegate = UIApplication.shared().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        
        self.navigationItem.title = appDelegate.dateFormatter.string(from: ride!.date)
        
        let anotherButton = UIBarButtonItem(barButtonSystemItem: .action, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = anotherButton;
     
        updateValues()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

  
    func updateValues() {
        
        if let n = numberFormatter.string(from: ride!.summary.distance) {
            distance.text = "\(n) miles"
        } else {
            distance.text = emptyString
        }

        if let n = numberFormatter.string(from: NSNumber(value:ride!.summary.time_active)) {
            duration.text = n
        } else {
            duration.text = emptyString
        }

        if let n = numberFormatter.string(from: ride!.summary.speed_avg) {
            avgSpeed.text = "\(n) mph"
        } else {
            avgSpeed.text = emptyString
        }

        if let n = numberFormatter.string(from: ride!.summary.speed_max) {
            maxSpeed.text = "\(n) mph"
        } else {
            maxSpeed.text = emptyString
        }

        if let n = numberFormatter.string(from: NSNumber(value: ride!.summary.elevation_gain)) {
            ascent.text = "\(n) ft"
        } else {
            ascent.text = emptyString
        }

        if let n = numberFormatter.string(from: NSNumber(value: ride!.summary.elevation_loss)) {
            descent.text = "\(n) ft"
        } else {
            descent.text = emptyString
        }

        if let n = numberFormatter.string(from: NSNumber(value: ride!.summary.pace_avg)) {
            avgPace.text = "\(n) min/mile"
        } else {
            avgPace.text = emptyString
        }

        if let n = numberFormatter.string(from: NSNumber(value: ride!.summary.pace_max)) {
            maxPace.text = "\(n) min/mile"
        } else {
            maxPace.text = emptyString
        }

        if let n = numberFormatter.string(from: NSNumber(value: ride!.summary.cadence_avg)) {
            avgCadence.text = "\(n) rpm"
        } else {
            avgCadence.text = emptyString
        }

        if let n = numberFormatter.string(from: NSNumber(value: ride!.summary.cadence_max)) {
            maxCadence.text = "\(n) rpm"
        } else {
            maxCadence.text = emptyString
        }

        if let n = numberFormatter.string(from: NSNumber(value: ride!.summary.hr_avg)) {
            avgHr.text = "\(n) bpm"
        } else {
            avgHr.text = emptyString
        }

        if let n = numberFormatter.string(from: NSNumber(value:ride!.summary.hr_max)) {
            maxHr.text = "\(n) bpm"
        } else {
            maxHr.text = emptyString
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return super.numberOfSections(in: tableView)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return super.tableView(tableView, heightForRowAt:indexPath)
    }
    
    override func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        return super.tableView(tableView, indentationLevelForRowAt:indexPath)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return super.tableView(tableView, numberOfRowsInSection:section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return super.tableView(tableView, cellForRowAt: indexPath)
    }

}


