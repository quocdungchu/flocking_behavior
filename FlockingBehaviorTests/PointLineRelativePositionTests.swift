//
//  SegmentTests.swift
//  FlockingBehaviorTests
//
//  Created by Quoc Dung Chu on 14/10/2017.
//  Copyright © 2017 quoc. All rights reserved.
//

import XCTest
@testable import FlockingBehavior

class PointLineRelativePositionTests: XCTestCase {
    
    func testPointIsLeftOfLine() {
        XCTAssert(leftOf(start: Vector(1,-1), end: Vector(1,1), point: Vector(0,0)) > 0)
        XCTAssert(leftOf(start: Vector(-2,-3), end: Vector(2,3), point: Vector(-4,5)) > 0)
    }
    
    func testPointIsOnLine() {
        XCTAssert(leftOf(start: Vector(1,-1), end: Vector(1,1), point: Vector(1,2)) == 0)
        XCTAssert(leftOf(start: Vector(-2,-3), end: Vector(2,3), point: Vector(-0,0)) == 0)
    }
    
    func testPointIsRIghtOfLine() {
        XCTAssert(leftOf(start: Vector(1,-1), end: Vector(1,1), point: Vector(2,1)) < 0)
        XCTAssert(leftOf(start: Vector(-2,-3), end: Vector(2,3), point: Vector(4,-5)) < 0)
    }
}
