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
        let obstacleBuilder = ObstacleBuilder()

        obstacleBuilder.addObstacle(with: [
            Vector(0,0),
            Vector(0,1),
            Vector(1,0),
        ])
        
        obstacleBuilder.addObstacle(with: [
            Vector(0,0),
            Vector(0,-1),
            Vector(-1,0),
        ])
        
        let optimalSplit = ObstacleKTree.findOptimalSplitIndex(obstacles: obstacleBuilder.obstacles)
        
        XCTAssertNotNil(optimalSplit)
        XCTAssertEqual(optimalSplit!.leftCount, 3)
        XCTAssertEqual(optimalSplit!.rightCount, 2)
        XCTAssertEqual(optimalSplit!.index, 0)
    }
    
    func testQueryingObstacle(){
        let obstacleBuilder = ObstacleBuilder()
        obstacleBuilder.addObstacle(with: [
            Vector(0,0),
            Vector(0,1),
            Vector(1,1),
            Vector(1,0),
        ])
        
        obstacleBuilder.addObstacle(with: [
            Vector(2,0),
            Vector(2,1),
            Vector(3,1),
            Vector(2,0),
        ])
        
        let kTree = ObstacleKTree(obstacles: obstacleBuilder.obstacles)
        
        var queriesObstacles = [Obstacle]()
        
        kTree.query(origin: Vector(1.2, 0), range: 0.3) { queriesObstacles.append($0) }
        
        XCTAssertEqual(queriesObstacles.count, 1)
        XCTAssertEqual(queriesObstacles[0].point, Vector(1,1))

    }
}
