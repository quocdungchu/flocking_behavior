//
//  LineComputerTests.swift
//  FlockingBehaviorTests
//
//  Created by Quoc Dung Chu on 29/10/2017.
//  Copyright © 2017 quoc. All rights reserved.
//

import XCTest
@testable import FlockingBehavior

class LineComputerTests: XCTestCase {
    func testLinearProgram1(){
        let result = LineComputer.linearProgram1(
            lines: [
                Line(point: Vector(-0.4, 0.0), direction: Vector(0, -1))
            ],
            lineIndex: 0,
            radius: 1.0,
            optimalVelocity: Vector(-0.5, 0),
            directionOptimal: true
        )
        XCTAssertNotNil(result)
        XCTAssertNotEqual(result!.y, 0.0)

    }
}
