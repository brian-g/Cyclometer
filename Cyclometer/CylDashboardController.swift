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

    private lazy var numberFormatter = NumberFormatter()
    private lazy var timeFormatter = DateFormatter()

    private lazy var rideManager = CylRideManager()
    
    private var _maxSpeed = 0.0
    
    private lazy var _sensorManager = SensorManager.sharedManager
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        numberFormatter.formatterBehavior = NumberFormatter.Behavior.default
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
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
    
    @IBAction func toggleRideState(_ sender: UIBarButtonItem) {
        
        let buttonTag = sender.tag

        secondButton.hide()

        switch buttonTag {
            case Play:
                firstButton.tag = Pause
                firstButton.image = pauseImage
            
                speed.speed.text = "25.4"
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
                
                let alert = UIAlertController(title: "Keep Ride?", message: "When you keep your ride, it will be available for analysis.", preferredStyle: UIAlertControllerStyle.actionSheet)
                
                alert.addAction(UIAlertAction(title: "Keep", style: UIAlertActionStyle.default, handler: { ( action: UIAlertAction ) in
                    NSLog("Keep")
                    
                    self.firstButton.tag = self.Play
                    self.firstButton.image = self.playImage
                    self.zeroDashboard()
                    
                }))

                alert.addAction(UIAlertAction(title: "Discard", style: UIAlertActionStyle.destructive, handler: { ( action: UIAlertAction ) in
                    NSLog("Discard")
                    
                    self.firstButton.tag = self.Play
                    self.firstButton.image = self.playImage
                    self.zeroDashboard()
                    
                }))

                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { ( action: UIAlertAction ) in
                    
                    NSLog("Cancel")
                    
                    self.secondButton.show(self.playImage, title:nil)
                }))

                self.present(alert, animated: true, completion: { () in
                    NSLog("Done")
                })
                
            
            case Pause:
                firstButton.tag = Stop
                firstButton.image = stopImage
                
                secondButton.isEnabled = true
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
        
        distanceDuration.distance.text = numberFormatter.string(from: 0)
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
        geo.el.text = numberFormatter.string(from: 0)
        geo.asc.text = "—"
        geo.des.text = "—"
    }
    
    func speed(_ _speed : Double) {
        self.speed.speed.text = numberFormatter.string(from: _speed)
        if (_speed > _maxSpeed) {
            _maxSpeed = _speed
        }
    }

    func updateHeartRate(_ bpm: UInt16) {
        self.biometrics.hr.text = bpm.description
    }
}
