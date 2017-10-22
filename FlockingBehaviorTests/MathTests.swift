//
//  MathTests.swift
//  FlockingBehaviorTests
//
//  Created by Quoc Dung Chu on 14/10/2017.
//  Copyright © 2017 quoc. All rights reserved.
//

import XCTest
@testable import FlockingBehavior

class MathTests: XCTestCase {
    
    func testIntersection() {
        let point = intersection(start1: Vector(-1,0), end1: Vector(3,2), start2: Vector(2,0), end2: Vector(0,2))
        XCTAssertEqual(point, Vector(1,1))
    }
    
    func testSquaredDistancePointToSegment() {
        XCTAssertEqual(1, squaredDistance(point: Vector.zero, segmentStart: Vector(1,0), segmentEnd: Vector(1,1)))
        XCTAssertEqual(16, squaredDistance(point: Vector(1, 5), segmentStart: Vector(1,0), segmentEnd: Vector(1,1)))
    }
    
    func testSquaredDistancePointToLine() {
        XCTAssertEqual(1, squaredDistance(point: Vector.zero, lineStart: Vector(1,0), lineEnd: Vector(1,1)))
        XCTAssertEqual(0, squaredDistance(point: Vector(1, 5), lineStart: Vector(1,0), lineEnd: Vector(1,1)))
        XCTAssertEqual(2, squaredDistance(point: Vector.zero, lineStart: Vector(0,2), lineEnd: Vector(2,0)))
    }
}
