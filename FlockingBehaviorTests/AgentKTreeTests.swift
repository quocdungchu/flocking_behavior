//
//  AgentKTreeTests.swift
//  FlockingBehaviorTests
//
//  Created by Quoc Dung Chu on 21/10/2017.
//  Copyright © 2017 quoc. All rights reserved.
//

import XCTest
@testable import FlockingBehavior

class AgentKTreeTests: XCTestCase {
    
    func testBuildNodes(){
        
        let positions = [
            Vector(2,0),
            Vector(3,0),
            Vector(8,0),
            Vector(7,0),
            Vector(9,0),
            Vector(6,0),
            Vector.zero,
            Vector(1,0),
        ]
        
        let agents = positions.map {
            Agent(position: $0, radius: 10, maxSpeed: 0.0)
        }
        
        let kTree = AgentKTree(agents: agents, maxLeafSize: 1)
        XCTAssertEqual(
            kTree.agents.map { $0.position },
            agents.map { $0.position }.sorted { $0.x < $1.x }
        )
    }
    
    func testQuery1(){
        let positions = [
            Vector(0,0),
            Vector(1,0),
            Vector(0,1),
            Vector(1,1),
        ]
        
        let agents = positions.map {
            Agent(position: $0, radius: 10, maxSpeed: 0.0)
        }
        
        let kTree = AgentKTree(agents: agents, maxLeafSize: 1)
        
        var queried = [Agent]()
        
        kTree.queryAgents(point: Vector(0.2, 0.2), range: 0.3) {
            queried.append($0)
        }
        
        XCTAssertTrue(queried.contains { $0.position == Vector(0,0) })
        
        XCTAssertFalse(queried.contains { $0.position == Vector(1,0) })
        XCTAssertFalse(queried.contains { $0.position == Vector(1,1) })
        XCTAssertFalse(queried.contains { $0.position == Vector(0,1) })
    }
    
    func testQuery2(){
        let positions = [
            Vector(0,0),
            Vector(1,0),
            Vector(0,1),
            Vector(1,1),
        ]
        
        let agents = positions.map {
            Agent(position: $0, radius: 10, maxSpeed: 0.0)
        }
        
        let kTree = AgentKTree(agents: agents, maxLeafSize: 1)
        
        var queried = [Agent]()
        
        kTree.queryAgents(point: Vector(0.5, 0.5), range: 0.8) {
            queried.append($0)
        }
        
        XCTAssertTrue(queried.contains { $0.position == Vector(0,0) })
        XCTAssertTrue(queried.contains { $0.position == Vector(1,0) })
        XCTAssertTrue(queried.contains { $0.position == Vector(1,1) })
        XCTAssertTrue(queried.contains { $0.position == Vector(0,1) })
    }
    
    func testQuery3(){
        let positions = [
            Vector(0,0),
            Vector(1,0),
            Vector(2,0),
            
            Vector(0,1),
            Vector(1,1),
            Vector(2,1),
            
            Vector(0,2),
            Vector(1,2),
            Vector(2,2)
        ]
        
        let agents = positions.map {
            Agent(position: $0, radius: 10, maxSpeed: 0.0)
        }
        
        let kTree = AgentKTree(agents: agents, maxLeafSize: 1)
        
        var queried = [Agent]()
        
        kTree.queryAgents(point: Vector(0.5, 0.5), range: 2) {
            queried.append($0)
        }
        
        XCTAssertTrue(queried.contains { $0.position == Vector(0,0) })
        XCTAssertTrue(queried.contains { $0.position == Vector(1,0) })
        XCTAssertTrue(queried.contains { $0.position == Vector(1,1) })
        XCTAssertTrue(queried.contains { $0.position == Vector(0,1) })
    }
    
    func testQuery4(){
        let positions = [
            Vector(0,0),
            Vector(1,0),
            Vector(2,0),
            
            Vector(0,1),
            Vector(1,1),
            Vector(2,1),
            
            Vector(0,2),
            Vector(1,2),
            Vector(2,2)
        ]
        
        let agents = positions.map {
            Agent(position: $0, radius: 10, maxSpeed: 0.0)
        }
        
        let kTree = AgentKTree(agents: agents, maxLeafSize: 1)
        
        var queried = [Agent]()
        
        kTree.queryAgents(point: Vector(0.5, 0.5), range: 1) {
            queried.append($0)
        }
        
        XCTAssertTrue(queried.contains { $0.position == Vector(0,0) })
        XCTAssertTrue(queried.contains { $0.position == Vector(1,0) })
        XCTAssertTrue(queried.contains { $0.position == Vector(1,1) })
        XCTAssertTrue(queried.contains { $0.position == Vector(0,1) })
        
        XCTAssertFalse(queried.contains { $0.position == Vector(2,0) })
        XCTAssertFalse(queried.contains { $0.position == Vector(2,1) })
        XCTAssertFalse(queried.contains { $0.position == Vector(0,2) })
        XCTAssertFalse(queried.contains { $0.position == Vector(1,2) })
        XCTAssertFalse(queried.contains { $0.position == Vector(2,2) })
    }
}
