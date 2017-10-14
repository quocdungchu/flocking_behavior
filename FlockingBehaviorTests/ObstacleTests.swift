//
//  ObstacleTests.swift
//  FlockingBehaviorTests
//
//  Created by Quoc Dung Chu on 14/10/2017.
//  Copyright © 2017 quoc. All rights reserved.
//

import XCTest
@testable import FlockingBehavior

class ObstacleTests: XCTestCase {
    
    func testBuildingObstacleConvexe() {
        let vertices = [
            Vector(0,0),
            Vector(1,0),
            Vector(1,-1),
            Vector(0,-1)
        ]
        
        let obstacle1 = Obstacle.buildObstacle(vertices: vertices)
        
        XCTAssertNotNil(obstacle1)
        XCTAssertEqual(obstacle1!.point, vertices[0])
        XCTAssertTrue(obstacle1!.convexe)
        XCTAssertEqual(obstacle1!.pointCount, vertices.count)
        
        let obstacle2 = obstacle1?.next
        
        XCTAssertNotNil(obstacle2)
        XCTAssertEqual(obstacle2!.point, vertices[1])
        XCTAssertTrue(obstacle2!.convexe)
        
        let obstacle3 = obstacle2?.next
        
        XCTAssertNotNil(obstacle3)
        XCTAssertEqual(obstacle3!.point, vertices[2])
        XCTAssertTrue(obstacle3!.convexe)
        
        let obstacle4 = obstacle3?.next
        
        XCTAssertNotNil(obstacle4)
        XCTAssertEqual(obstacle4!.point, vertices[3])
        XCTAssertTrue(obstacle4!.convexe)
    }
    
    func testBuildingObstacleNonConvexe() {
        let vertices = [
            Vector(0,2),
            Vector(1,0),
            Vector(0,1),
            Vector(-1,0)
        ]
        
        let obstacle1 = Obstacle.buildObstacle(vertices: vertices)
        
        XCTAssertNotNil(obstacle1)
        XCTAssertEqual(obstacle1!.point, vertices[0])
        XCTAssertTrue(obstacle1!.convexe)
        
        let obstacle2 = obstacle1?.next
        
        XCTAssertNotNil(obstacle2)
        XCTAssertEqual(obstacle2!.point, vertices[1])
        XCTAssertTrue(obstacle2!.convexe)
        
        let obstacle3 = obstacle2?.next
        
        XCTAssertNotNil(obstacle3)
        XCTAssertEqual(obstacle3!.point, vertices[2])
        XCTAssertFalse(obstacle3!.convexe)
        
        let obstacle4 = obstacle3?.next
        
        XCTAssertNotNil(obstacle4)
        XCTAssertEqual(obstacle4!.point, vertices[3])
        XCTAssertTrue(obstacle4!.convexe)        
    }
}
