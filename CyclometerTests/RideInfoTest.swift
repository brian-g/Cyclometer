//
//  RideInfoTest.swift
//  Cyclometer
//
//  Created by Brian on 10/16/16.
//  Copyright © 2016 Brian Glaeske. All rights reserved.
//

import XCTest

@testable import Cyclometer

class RideInfoTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testHeartRate() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        var rideInfo : RideInfo
        
        rideInfo = RideInfo()
        
        rideInfo.heartRate = 123
        rideInfo.heartRate = 145
        rideInfo.heartRate = 200
        rideInfo.heartRate = 100
        rideInfo.heartRate = 90
        
        XCTAssertEqual(rideInfo.heartRate, 90, "Heart rate is not 90")
        XCTAssertEqual(rideInfo.maxHeartRate, 200, "Max heart rate is not 200")
        XCTAssertEqual(rideInfo.avgHeartRate, 131.6, "Average heart rate is not 131.6" )
        
        rideInfo.clearStats()
        
        XCTAssertEqual(rideInfo.maxHeartRate, 0, "maxHeartRate after clearStats()")
        XCTAssertEqual(rideInfo.avgHeartRate, 0, "avgHeartRate after clearStats()")

    }

    func testSpeed() {
        var rideInfo = RideInfo()

        rideInfo.start()
        rideInfo.speed = 0
        rideInfo.speed = 10
        rideInfo.speed = 10.3
        rideInfo.speed = 11.5
        rideInfo.speed = 13
        rideInfo.speed = 15
        rideInfo.speed = 17
        rideInfo.speed = 17.25
        rideInfo.speed = 15
        rideInfo.totalDistance = 100
        sleep(5)
        rideInfo.end()
        
        XCTAssertEqual(rideInfo.speed, 15)
        XCTAssertEqual(rideInfo.maxSpeed, 17.25)
        XCTAssertEqual(rideInfo.avgSpeed.rounded(), 20)
        XCTAssertEqual(rideInfo.duration.rounded(), 5)
        
        rideInfo.start()
        sleep(5)
        rideInfo.end()
        
        XCTAssertEqual(rideInfo.duration.rounded(), 10)
        XCTAssertEqual(rideInfo.activeDuration.rounded(), 15)
        XCTAssertEqual(rideInfo.pace.rounded(), 0) // Need more data to get pace information.
        
        rideInfo.clearStats()
        XCTAssertEqual(rideInfo.duration, 0)
        XCTAssertEqual(rideInfo.activeDuration, 0)
        XCTAssertEqual(rideInfo.duration, 0)
        XCTAssertEqual(rideInfo.pace, 0)
        XCTAssertEqual(rideInfo.avgSpeed, 0)
        XCTAssertEqual(rideInfo.totalDistance, 0)
        XCTAssertEqual(rideInfo.maxSpeed, 0)
        XCTAssertEqual(rideInfo.speed, 15)
    }
    
    func testElevation() {
        var rideInfo = RideInfo()
        
        rideInfo.elevation = 10
        rideInfo.elevation = 11 // +1
        rideInfo.elevation = 8 // -3
        rideInfo.elevation = 12 // +5
        rideInfo.elevation = 15 // +8
        rideInfo.elevation = 10 // -8
        
        XCTAssertEqual(rideInfo.elevation, 10)
        XCTAssertEqual(rideInfo.ascent, 8)
        XCTAssertEqual(rideInfo.descent, 8)
        
        rideInfo.clearStats()
        
        XCTAssertEqual(rideInfo.elevation, 0)
        XCTAssertEqual(rideInfo.ascent, 0)
        XCTAssertEqual(rideInfo.descent, 0)
    }
    
    func testAutoPause() {
        var rideInfo = RideInfo()

        rideInfo.start()
        rideInfo.speed = 10
        sleep(1)
        rideInfo.speed = 0
        let mark = Date()
        sleep(2)
        
        
        XCTAssertNotNil(rideInfo.speedBecameZeroOn)
        
        // Don't need super precision. Round off the precision
        let x = (rideInfo.speedBecameZeroOn!.timeIntervalSince1970 / 10000).rounded()
        let y = (mark.timeIntervalSince1970 / 10000).rounded()
        
        XCTAssertEqual(x, y)
        
        rideInfo.speed = 12
        
        XCTAssertNil(rideInfo.speedBecameZeroOn)
    }
}
