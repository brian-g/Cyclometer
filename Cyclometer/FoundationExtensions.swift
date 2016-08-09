//
//  FoundationExtentions.swift
//  Cyclometer
//
//  Created by brian on 5/9/15.
//  Copyright (c) 2015 Brian Glaeske. All rights reserved.
//

import Foundation

extension Timer {
    /**
    Creates and schedules a one-time `NSTimer` instance.
    
    - parameter delay: The delay before execution.
    - parameter handler: A closure to execute after `delay`.
    
    - returns: The newly-created `NSTimer` instance.
    */
    class func schedule(delay: TimeInterval, handler: (CFRunLoopTimer?) -> Void) -> Timer {
        let fireDate = delay + CFAbsoluteTimeGetCurrent()
        let timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, fireDate, 0, 0, 0, handler)
        CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, CFRunLoopMode.commonModes)
        return timer!
    }
    
    /**
    Creates and schedules a repeating `NSTimer` instance.
    
    - parameter repeatInterval: The interval between each execution of `handler`. Note that individual calls may be delayed; subsequent calls to `handler` will be based on the time the `NSTimer` was created.
    - parameter handler: A closure to execute after `delay`.
    
    - returns: The newly-created `NSTimer` instance.
    */
    class func schedule(repeatInterval interval: TimeInterval, handler: (CFRunLoopTimer?) -> Void) -> Timer {
        let fireDate = interval + CFAbsoluteTimeGetCurrent()
        let timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, fireDate, interval, 0, 0, handler)
        CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, CFRunLoopMode.commonModes)
        return timer!
    }
}

extension Float {
    
    var miles : Float {
        return self / 1609.347
    }
    
    var km : Float {
        return self * 1000
    }
    
    // Assumes meters/second
    var mph : Float {
        return self * 3600 * self.miles
    }
    
    var kph : Float {
        return self * 3600
    }
}

extension Double {
    
    // Assumes meters
    var miles : Double {
        return self / kMetersInMile
    }
    
    var km : Double {
        return self * 1000
    }
    
    // Assumes meters/second
    var mph : Double {
        return self * kSecondsInHour / kMetersInMile
    }

    var kph : Double {
        return self * kSecondsInHour
    }
    
    var ft : Double {
        return self * kMetersInFeet
    }
}
