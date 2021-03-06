//
//  Protocols.swift
//  Cyclometer
//
//  Created by Brian on 2/3/15.
//  Copyright (c) 2015 Brian Glaeske. All rights reserved.
//

import Foundation
import CoreLocation

protocol RideProtocol {
 
    var rideInfo : RideInfo { get }
    var state : RideState { get set }
    
}
