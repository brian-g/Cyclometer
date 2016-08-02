//
//  Globals.swift
//  Cyclometer
//
//  Created by Brian on 7/25/16.
//  Copyright © 2016 Brian Glaeske. All rights reserved.
//

import Foundation
import UIKit

let fontName = "GillSans-Light"
let captionFontSize : CGFloat = 14.0
let heroFontSize : CGFloat = 128.0
let majorFontSize : CGFloat = 56.0
let minorFontSize : CGFloat = (heroFontSize / 4)
let globalTintColor = #colorLiteral(red: 0.3449069262, green: 0.7287212014, blue: 0.01709888875, alpha: 1)

let captionColor = UIColor(white: 0.25, alpha: 1.0)


let kAutoPause = "AutoPause"
let kUseInBackground = "UseInBackground"
let kAutoDim = "AutoDim"
let kUnits = "Units"
let kWheelSize = "Wheelsize"
let kDevices = "Devices"
let kSensorName = "SensorName"
let kSensorId = "SensorID"
let kSensorCap = "SensorCap"
let kDoNotDisturb = "DoNotDisturb"

var currentUnits = Units.imperial


let kMetersInMile = 1609.347
let kKmInMile = kMetersInMile / 1000.0
let kSecondsInMin = 60.0
let kMinutesInHour = 60.0
let kSecondsInHour = 3600.0
let kMilesInMeter = 0.00062137
let kMetersInKm = 1000.0