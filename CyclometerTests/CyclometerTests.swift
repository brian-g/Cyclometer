//
//  CyclometerTests.swift
//  CyclometerTests
//
//  Created by Brian on 8/12/16.
//  Copyright © 2016 Brian Glaeske. All rights reserved.
//

import XCTest

@testable import Cyclometer

class CyclometerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMeasure() {
        Measure.currentUnits = .imperial
        XCTAssertEqual(Measure.currentUnits, .imperial, "Not equal to .imperial")
        
        Measure.currentUnits = .metric
        XCTAssertEqual(Measure.currentUnits, .metric, "Not equal to .metric")
        
        XCTAssertEqual(Measure.distance(asKilometers:1000.0), 1.0)
        XCTAssertEqual(Measure.distance(1000.0), 1.0)

    
    
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
