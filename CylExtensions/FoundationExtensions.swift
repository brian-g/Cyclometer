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

    // Assumes meters
    func inMiles() -> Float {
        return self * 0.00062137
    }
    
    func inKM() -> Float {
        return self * 1000
    }
    
    // Assumes meters/second
    func inMilesPerHour() -> Float {
        return self * 3600 * self.inMiles()
    }
    
    func inKiloMetersPerHour() -> Float {
        return self * 3600
    }
}

extension Double {
    
    // Assumes meters
    func inMiles() -> Double {
        return self * 0.00062137
    }
    
    func inKM() -> Double {
        return self * 1000
    }
    
    // Assumes meters/second
    func inMilesPerHour() -> Double {
        return 3600 * self.inMiles()
    }

    func inKiloMetersPerHour() -> Double {
        return self * 3600;
    }
}
