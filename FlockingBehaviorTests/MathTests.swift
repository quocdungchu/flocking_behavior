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
}
