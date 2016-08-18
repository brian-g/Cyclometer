//
//  ViewController.swift
//  Cyclometer
//
//  Created by Brian on 12/31/14.
//  Copyright (c) 2014 Brian Glaeske. All rights reserved.
//

import UIKit
import CoreData

class RideDetailsController : UITableViewController {

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
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
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
        

        if let n = numberFormatter.string(from: NSNumber(value: ride!.summary.distance)) {
            distance.text = "\(n) miles"
        } else {
            distance.text = emptyString
        }

        if let n = numberFormatter.string(from: NSNumber(value: ride!.summary.time_active)) {
            duration.text = n
        } else {
            duration.text = emptyString
        }

        if let n = numberFormatter.string(from: NSNumber(value: ride!.summary.speed_avg)) {
            avgSpeed.text = "\(n) mph"
        } else {
            avgSpeed.text = emptyString
        }

        if let n = numberFormatter.string(from: NSNumber(value: ride!.summary.speed_max)) {
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


