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
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let timeIntervalFormatter = DateComponentsFormatter()
    private let numberFormatter = NumberFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        timeIntervalFormatter.allowedUnits = [.hour, .minute]
        timeIntervalFormatter.unitsStyle = .abbreviated
    
        self.navigationItem.title = appDelegate.dateFormatter.string(from: ride!.date)
        
        let anotherButton = UIBarButtonItem(barButtonSystemItem: .action, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = anotherButton;
     
        updateValues()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func makeAttributedString(_ value : String, units : String) -> NSAttributedString {

<<<<<<< HEAD
        let valueAttr = [ NSFontAttributeName: UIFont(name: fontName, size: valueFontSize)! ]
        let unitsAttr = [ NSFontAttributeName: UIFont(name: fontName, size: unitFontSize)! ]
=======
        let valueAttr = [ NSAttributedStringKey.font: UIFont(name: fontName, size: valueFontSize)! ]
        let unitsAttr = [ NSAttributedStringKey.font: UIFont(name: fontName, size: unitFontSize)! ]
>>>>>>> master
        
        let str = NSMutableAttributedString(string: value, attributes: valueAttr)
        let unitsStr = NSAttributedString(string: units, attributes: unitsAttr)
        
        str.append(unitsStr)
        
        return str
    }
    
    private func makeDateComponentAttributedString(_ value : String) -> NSAttributedString {
        // shit. This is going to localize like crap
<<<<<<< HEAD
        let valueAttr = [ NSFontAttributeName: UIFont(name: fontName, size: valueFontSize)! ]
        let unitsAttr = [ NSFontAttributeName: UIFont(name: fontName, size: unitFontSize)! ]
=======
        let valueAttr = [ NSAttributedStringKey.font: UIFont(name: fontName, size: valueFontSize)! ]
        let unitsAttr = [ NSAttributedStringKey.font: UIFont(name: fontName, size: unitFontSize)! ]
>>>>>>> master
        let nsStr = value as NSString
        
        let hourUnitPos = nsStr.range(of: "h")
        let minUnitPos = nsStr.range(of: "m")
        let str = NSMutableAttributedString(string: value, attributes: valueAttr)
        str.addAttributes(unitsAttr, range: hourUnitPos)
        str.addAttributes(unitsAttr, range: minUnitPos)
        
        return str
    }
    
    func updateValues() {
        
        let summary = ride!.summary
        
        if let n = numberFormatter.string(from: NSNumber(value: Measure.distance(Double(exactly: summary.distance)!))) {
            distance.attributedText = makeAttributedString(n, units: Measure.distanceLabel.lowercased())
        } else {
            distance.text = emptyString
        }

        let ti = TimeInterval(summary.time_active)
        if let n = timeIntervalFormatter.string(from: ti) {
            duration.attributedText = makeDateComponentAttributedString(n)
        } else {
            duration.text = emptyString
        }

        if let n = numberFormatter.string(from: NSNumber(value: Measure.velocity(Double(summary.speed_avg)))) {
            avgSpeed.attributedText = makeAttributedString(n, units: Measure.speedLabel.lowercased())
        } else {
            avgSpeed.text = emptyString
        }

        if let n = numberFormatter.string(from: NSNumber(value: ride!.summary.speed_max)) {
            maxSpeed.attributedText = makeAttributedString(n, units: Measure.speedLabel.lowercased())
        } else {
            maxSpeed.text = emptyString
        }

        if let n = numberFormatter.string(from: NSNumber(value: ride!.summary.elevation_gain)) {
            ascent.attributedText = makeAttributedString(n, units: Measure.smallDistanceLabel.lowercased())
        } else {
            ascent.text = emptyString
        }

        if let n = numberFormatter.string(from: NSNumber(value: ride!.summary.elevation_loss)) {
            descent.attributedText = makeAttributedString(n, units: Measure.smallDistanceLabel.lowercased())
        } else {
            descent.text = emptyString
        }

        if let n = numberFormatter.string(from: NSNumber(value: ride!.summary.pace_avg)) {
            avgPace.attributedText = makeAttributedString(n, units: Measure.paceLabel.lowercased())
        } else {
            avgPace.text = emptyString
        }

        if let n = numberFormatter.string(from: NSNumber(value: ride!.summary.pace_max)) {
            maxPace.attributedText = makeAttributedString(n, units: Measure.paceLabel.lowercased())
        } else {
            maxPace.text = emptyString
        }

        if let n = numberFormatter.string(from: NSNumber(value: ride!.summary.cadence_avg)) {
            avgCadence.attributedText = makeAttributedString(n, units: "rpm")
        } else {
            avgCadence.text = emptyString
        }

        if let n = numberFormatter.string(from: NSNumber(value: ride!.summary.cadence_max)) {
            maxCadence.attributedText = makeAttributedString(n, units: "rpm")
        } else {
            maxCadence.text = emptyString
        }

        if let n = numberFormatter.string(from: NSNumber(value: ride!.summary.hr_avg)) {
            avgHr.attributedText = makeAttributedString(n, units: "bpm")
        } else {
            avgHr.text = emptyString
        }

        if let n = numberFormatter.string(from: NSNumber(value:ride!.summary.hr_max)) {
            maxHr.attributedText = makeAttributedString(n, units: "bpm")
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


