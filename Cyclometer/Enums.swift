//
//  Enums.swift
//  Cyclometer
//
//  Created by Brian on 7/28/16.
//  Copyright © 2016 Brian Glaeske. All rights reserved.
//

import Foundation

enum Units : Int {
    case imperial = 0
    case metric = 1
    
    func description() -> String {
        switch self {
        case .imperial:
            return "Imperial"
        case .metric:
            return "Metric"
        }
    }
}

enum RideState : Int {
    case play = 0
    case stop = 1
    case pause = 2
    case autoPause = 3
}
