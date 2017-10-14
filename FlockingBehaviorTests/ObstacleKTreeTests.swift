//
//  ObstacleKTreeTests.swift
//  FlockingBehaviorTests
//
//  Created by Quoc Dung Chu on 14/10/2017.
//  Copyright © 2017 quoc. All rights reserved.
//

import XCTest
@testable import FlockingBehavior

class ObstacleKTreeTests: XCTestCase {
    
    func testFindingOptimalSplit() {
        let simulator = RVOSimulator()

        simulator.addObstacle(with: [
            Vector(0,0),
            Vector(0,1),
            Vector(1,0),
        ])
        
        simulator.addObstacle(with: [
            Vector(0,0),
            Vector(0,-1),
            Vector(-1,0),
        ])
        
        let optimalSplit = ObstacleKTree.findOptimalSplitIndex(obstacles: simulator.obstacles)
        
        XCTAssertNotNil(optimalSplit)
        XCTAssertEqual(optimalSplit!.leftCount, 2)
        XCTAssertEqual(optimalSplit!.rightCount, 3)
        XCTAssertEqual(optimalSplit!.index, 1)
    }
}
