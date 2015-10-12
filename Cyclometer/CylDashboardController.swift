//
//  CylDashboardController.swift
//  Cyclometer
//
//  Created by Brian on 1/16/15.
//  Copyright (c) 2015 Brian Glaeske. All rights reserved.
//

import UIKit
import Foundation
import CoreBluetooth

class CylDashboardController : UIViewController, CBPeripheralDelegate {
    
    let Play = 0
    let Stop = 1
    let Pause = 2

    let playImage = UIImage(named: "Play")
    let pauseImage = UIImage(named: "Pause")
    let stopImage = UIImage(named: "Stop")
    
    @IBOutlet weak var firstButton: UIBarButtonItem!
    @IBOutlet weak var secondButton: UIBarButtonItem!
    
    @IBOutlet weak var speed: CylSpeedDashboardView!
    @IBOutlet weak var distanceDuration: CylDistanceTimeDashboardView!
    @IBOutlet weak var cadence: CylCadenceDashboardView!
    @IBOutlet weak var biometrics: CylHeartRateDashboardView!
    @IBOutlet weak var geo: CylGeoDashboardView!

    private lazy var numberFormatter = NSNumberFormatter()
    private lazy var timeFormatter = NSDateFormatter()

    private lazy var rideManager = CylRideManager()
    
    private var _maxSpeed = 0.0
    
    private lazy var _sensorManager = SensorManager.sharedManager
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        numberFormatter.formatterBehavior = NSNumberFormatterBehavior.BehaviorDefault
        numberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        numberFormatter.formatWidth = 1
        numberFormatter.nilSymbol = "–"
        numberFormatter.alwaysShowsDecimalSeparator = false
        

        firstButton.tag = Play
        firstButton.image = playImage
        
        secondButton.hide()

        zeroDashboard()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func toggleRideState(sender: UIBarButtonItem) {
        
        let buttonTag = sender.tag

        secondButton.hide()

        switch buttonTag {
            case Play:
                firstButton.tag = Pause
                firstButton.image = pauseImage
            
                speed.speed.text = "15.4"
                speed.avgSpeed.text = "10.3"
                speed.maxSpeed.text = "22.1"
            
                distanceDuration.distance.text = "15.3"
                distanceDuration.duration.text = "0:59.12"
                distanceDuration.pace.text = "3.86"
            
                cadence.cadence.text = "78"
                cadence.max.text = "105"
                cadence.avg.text = "76"
            
                geo.el.text = "894"
                geo.asc.text = "103"
                geo.des.text = "123"
            
                _sensorManager.updateHeartRate = updateHeartRate
                
            case Stop:
                
                let alert = UIAlertController(title: "Save Ride?", message: "When you save your ride, results will also be posted to any accounts you have set up", preferredStyle: UIAlertControllerStyle.ActionSheet)
                
                alert.addAction(UIAlertAction(title: "Save", style: UIAlertActionStyle.Default, handler: { ( action: UIAlertAction ) in
                    NSLog("Save")
                    
                    self.firstButton.tag = self.Play
                    self.firstButton.image = self.playImage
                    self.zeroDashboard()
                    
                }))

                alert.addAction(UIAlertAction(title: "Don't save", style: UIAlertActionStyle.Destructive, handler: { ( action: UIAlertAction ) in
                    NSLog("Don't save")
                    
                    self.firstButton.tag = self.Play
                    self.firstButton.image = self.playImage
                    self.zeroDashboard()
                    
                }))

                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { ( action: UIAlertAction ) in
                    
                    NSLog("Cancel")
                    
                    self.secondButton.show(self.playImage, title:nil)
                }))

                self.presentViewController(alert, animated: true, completion: { () in
                    NSLog("Done")
                })
                
            
            case Pause:
                firstButton.tag = Stop
                firstButton.image = stopImage
                
                secondButton.enabled = true
                secondButton.show(playImage, title:nil)
                secondButton.tag = Play
            
            default:
                NSLog("You're screwed")
            
        }
    }
    
    func zeroDashboard() {
   
        speed.speed.text = "—.–"
        speed.speedUnits.text = "MPH"
        speed.avgSpeed.text = "—.–"
        speed.maxSpeed.text = "—.–"
        
        distanceDuration.distance.text = numberFormatter.stringFromNumber(0)
        distanceDuration.distanceUnits.text = "MILES"
        distanceDuration.duration.text = (NSString(format: "%d:%.2d.%d", 0, 0, 0) as String)
        distanceDuration.pace.text = "—.–"
        distanceDuration.paceCaption.text = "MIN/MILE"
        
        cadence.cadence.text = "—"
        cadence.max.text = "—.–"
        cadence.avg.text = "—.–"

        biometrics.hr.text = "—"
        biometrics.max.text = "—.–"
        biometrics.avg.text = "—.–"
        
        geo.elUnits.text = "FEET"
        geo.el.text = numberFormatter.stringFromNumber(0)
        geo.asc.text = "—"
        geo.des.text = "—"
    }
    
    func speed(_speed : Double) {
        self.speed.speed.text = numberFormatter.stringFromNumber(_speed)
        if (_speed > _maxSpeed) {
            _maxSpeed = _speed
        }
    }

    func updateHeartRate(bpm: UInt16) {
        self.biometrics.hr.text = bpm.description
    }
}