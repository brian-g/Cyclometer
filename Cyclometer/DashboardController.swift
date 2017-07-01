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

protocol UnitsView {
    var units : Units { get set }
}



class DashboardController : UIViewController, CBPeripheralDelegate, RideManagerDelegate {
    
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
    
    var units : Units = .imperial {
        didSet {
            speed.units = Measure.currentUnits
            distanceDuration.units = Measure.currentUnits
            geo.units = Measure.currentUnits
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        numberFormatter.formatterBehavior = NumberFormatter.Behavior.default
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        numberFormatter.formatWidth = 1
        numberFormatter.nilSymbol = "–"
        numberFormatter.alwaysShowsDecimalSeparator = false
        

        firstButton.tag = RideState.play.rawValue
        firstButton.image = playImage
        
        secondButton.hide()
        
        rideManager.delegate = self
        
        NotificationCenter.default.addObserver(forName: UserDefaults.didChangeNotification, object: nil, queue: nil, using: { (aNotification) -> Void in
            self.units = Measure.currentUnits
        })

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func toggleRideState(_ sender: UIBarButtonItem) {
        
        let rideState : RideState = RideState(rawValue: sender.tag)!
        
        changeRideState(rideState)

    }
    
    func changeRideState(_ rideState: RideState) {
        secondButton.hide()
        
        switch rideState {
        case .play:
            
            rideManager.state = .play

            firstButton.tag = RideState.pause.rawValue
            firstButton.image = pauseImage
            
            
            distanceDuration.distance = 0.0
            distanceDuration.duration = 0.0
            distanceDuration.pace = 0.0
            
            _sensorManager.updateHeartRate = updateHeartRate
            
            
        case .stop:
            
            let alert = UIAlertController(title: "Keep Ride?", message: "When you keep your ride, it will be available for analysis.", preferredStyle: UIAlertControllerStyle.actionSheet)
            
            alert.addAction(UIAlertAction(title: "Keep", style: UIAlertActionStyle.default, handler: { ( action: UIAlertAction ) in
                self.firstButton.tag = RideState.play.rawValue
                self.firstButton.image = self.playImage
                self.zeroDashboard()
            }))
            
            alert.addAction(UIAlertAction(title: "Discard", style: UIAlertActionStyle.destructive, handler: { ( action: UIAlertAction ) in
                self.firstButton.tag = RideState.play.rawValue
                self.firstButton.image = self.playImage
                self.zeroDashboard()
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { ( action: UIAlertAction ) in
                self.secondButton.show(self.playImage, title:nil)
            }))
            
            self.present(alert, animated: true, completion: { () in
                NSLog("Done")
            })
            
            rideManager.state = .stop
            
        case .pause:
            firstButton.tag = RideState.stop.rawValue
            firstButton.image = stopImage
            
            secondButton.isEnabled = true
            secondButton.show(playImage, title:nil)
            secondButton.tag = RideState.play.rawValue
            
            rideManager.state = .pause
        case .autoPause:
            break
            
        }

        
    }
    
    func zeroDashboard() {
   
        speed.speed = 0.0
        
        distanceDuration.distance = 0.0
        distanceDuration.pace = 0.0
        distanceDuration.duration = 0.0
        
        cadence.cadence.text = "—"
        cadence.max.text = "—.–"
        cadence.avg.text = "—.–"

        biometrics.hr.text = "—"
        biometrics.max.text = "—.–"
        biometrics.avg.text = "—.–"
        
        geo.elevation = 0.0
    }
    
    func updateHeartRate(_ bpm: UInt16) {
        self.biometrics.hr.text = bpm.description
    }
    
    func informUserOfBadPermissions() {
        let alert = UIAlertController(title: "No permission to location services", message: "This application requires access to the GPS, but permission has not been granted. Go to Settings -> Cyclometer and change access.", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier! == "showMapAndRoute") {
            (segue.destination as! MapAndRouteController).ride = rideManager
        }
    }
    
    // RideManager Delegate Methods
    func locationDidUpdate(locations: [CLLocation]) {
        
        
        speed.speed = rideManager.rideInfo.speed
        speed.average = rideManager.rideInfo.avgSpeed
        distanceDuration.distance = rideManager.rideInfo.totalDistance
        distanceDuration.duration = rideManager.rideInfo.activeDuration
        distanceDuration.pace = rideManager.rideInfo.pace
        
        geo.elevation = (locations.last?.altitude)!
        
    }
    
    func rideDidPause() {
        changeRideState(RideState.pause)
    }
    
    func rideDidResume() {
        changeRideState(RideState.play)
    }
    
    func rideError(_ r: RideManagerError) {
        let alert = UIAlertController(title: "Location Authorization Denied", message: "You must give permission for this application to use your location, otherwise there isn't much point in using it.", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { ( action: UIAlertAction ) in
        }))
        
        alert.addAction(UIAlertAction(title: "Go To Settings", style: UIAlertActionStyle.destructive, handler: { ( action: UIAlertAction ) in
            if let appSettings = URL(string: UIApplicationOpenSettingsURLString + Bundle.main.bundleIdentifier!) {
                if UIApplication.shared.canOpenURL(appSettings) {
                    UIApplication.shared.open(appSettings)
                }
            }
        }))
        
        self.present(alert, animated: true, completion: { () in
            NSLog("Done")
        })
    }
}
