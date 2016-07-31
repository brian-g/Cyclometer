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
import CoreLocation

class DashboardController : UIViewController, CBPeripheralDelegate, RideManagerDelegate {
    
    let Play = 0
    let Stop = 1
    let Pause = 2

    let playImage = UIImage(named: "Play")
    let pauseImage = UIImage(named: "Pause")
    let stopImage = UIImage(named: "Stop")
    
    @IBOutlet weak var firstButton: UIBarButtonItem!
    @IBOutlet weak var secondButton: UIBarButtonItem!
    
    @IBOutlet weak var speed: SpeedDashboardView!
    @IBOutlet weak var distanceDuration: DistanceTimeDashboardView!
    @IBOutlet weak var cadence: CadenceDashboardView!
    @IBOutlet weak var biometrics: HeartRateDashboardView!
    @IBOutlet weak var geo: GeoDashboardView!

    private lazy var numberFormatter = NumberFormatter()
    private lazy var speedFormatter = NumberFormatter()
    private lazy var timeFormatter = DateFormatter()

    private lazy var rideManager = RideManager()
    
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
        
        rideManager.delegate = self
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
                if (rideManager.start() == false) {
                    informUserOfBadPermissions()
                    return
                }

                firstButton.tag = Pause
                firstButton.image = pauseImage
            
                
                distanceDuration.distance = 0.0
                distanceDuration.duration = 0.0
                distanceDuration.pace = 0.0
            
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
            
                _ = rideManager.stop()
            
            case Pause:
                firstButton.tag = Stop
                firstButton.image = stopImage
                
                secondButton.isEnabled = true
                secondButton.show(playImage, title:nil)
                secondButton.tag = Play
            
                _ = rideManager.stop()
            
            default:
                NSLog("You're screwed")
            
        }
    }
    
    func zeroDashboard() {
   
        speed.speed = 0.0
        speed.units = currentUnits
        
        distanceDuration.distance = 0.0
        distanceDuration.pace = 0.0
        distanceDuration.duration = 0.0
        
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
    
    func updateHeartRate(_ bpm: UInt16) {
        self.biometrics.hr.text = bpm.description
    }
    
    func informUserOfBadPermissions() {
        let alert = UIAlertController(title: "No permission to location services", message: "This application requires access to the GPS, but permission has not been granted. Go to Settings -> Cyclometer and change access.", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func locationDidUpdate(locations: [CLLocation]) {

        speed.speed = (locations.last?.speed)!
        speed.average = rideManager.average
        distanceDuration.distance = rideManager.totalDistance
        distanceDuration.duration = rideManager.duration
        distanceDuration.pace = rideManager.pace

        geo.el.text = locations.last?.altitude.description
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier! == "showMapAndRoute") {
            (segue.destinationViewController as! MapAndRouteController).ride = rideManager
        }
    }
}
