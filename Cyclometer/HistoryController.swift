//
//  HistoryController.swift
//  Cyclometer
//
//  Created by Brian on 7/30/16.
//  Copyright © 2016 Brian Glaeske. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class HistoryController : UITableViewController {
    
    var rides = [Ride]()
    var rowActions = [UITableViewRowAction]()
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let timeIntervalFormatter = DateComponentsFormatter()
    
    override func viewDidLoad() {
        
        timeIntervalFormatter.allowedUnits = [.hour, .minute]
        timeIntervalFormatter.unitsStyle = .abbreviated
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let managedContext = appDelegate.managedObjectContext!
        let fetchRequest : NSFetchRequest<NSFetchRequestResult> = Ride.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key:"date", ascending: false)

        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.fetchBatchSize = 20 // Optmize later
        
        do {
            let fetchResults = try managedContext.fetch(fetchRequest) as? [Ride]
            
            rides = fetchResults!
            
            if fetchResults!.count < 20 {
                
                let alert = UIAlertController(title: "Load demo data", message: nil, preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { ( action: UIAlertAction ) in
                    createDemoData(self.appDelegate.managedObjectContext!)
                    self.tableView!.reloadData()
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
        
        let cell : HistoryCell? = tableView.dequeueReusableCell(withIdentifier: "historyCell") as? HistoryCell
        if cell === nil {
            NSLog("Fuck");
        }
        
        let rideDate = rides[(indexPath as NSIndexPath).row].date as Date
        let summary = rides[(indexPath as NSIndexPath).row].summary as Summary
        
        cell?.title = appDelegate.dateFormatter.string(from: rideDate)
        cell?.description = "Duration: \(timeIntervalFormatter.string(from: summary.start, to: summary.end)!)"
        cell?.distance = Double(exactly: summary.distance)!
        cell?.mapImage = #imageLiteral(resourceName: "MapPlaceholder")

        return cell!
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if (rowActions.count > 0) { return rowActions }
        
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Delete", handler: doDeleteRow)
        rowActions.append(deleteAction)
        
        return rowActions
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        NSLog("prepareForSegue")
        
        let selectedRow = tableView.indexPathForSelectedRow
        let row = (selectedRow as NSIndexPath?)?.row
        
        if (row != nil) {
            (segue.destination as! RideDetailsController).ride = rides[row!]
        }
        
    }
    
    func doDeleteRow(action: UITableViewRowAction, rowIndex: IndexPath) {
        print ("Delete row called for \(rowIndex)")
    }
}
