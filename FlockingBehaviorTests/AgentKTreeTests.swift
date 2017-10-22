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
        let agents = [
            Agent(position: Vector(2,0)),
            Agent(position: Vector(3,0)),
            Agent(position: Vector(8,0)),
            Agent(position: Vector(7,0)),
            Agent(position: Vector(9,0)),
            Agent(position: Vector(6,0)),
            Agent(position: Vector.zero),
            Agent(position: Vector(1,0)),
        ]
        
        let kTree = AgentKTree(agents: agents, maxLeafSize: 1)
        XCTAssertEqual(
            kTree.agents.map { $0.position },
            agents.map { $0.position }.sorted { $0.x < $1.x }
        )
    }
    
    func testQuery1(){
        let agents = [
            Agent(position: Vector(0,0)),
            Agent(position: Vector(1,0)),
            Agent(position: Vector(0,1)),
            Agent(position: Vector(1,1)),
        ]
        
        let kTree = AgentKTree(agents: agents, maxLeafSize: 1)
        
        var queried = [Agent]()
        
        kTree.queryAgents(point: Vector(0.5, 0.5), range: 0.6) {
            queried.append($0)
        }
        
        XCTAssertTrue(queried.contains { $0.position == Vector(0,0) })
        XCTAssertTrue(queried.contains { $0.position == Vector(1,0) })
        XCTAssertTrue(queried.contains { $0.position == Vector(1,1) })
        XCTAssertTrue(queried.contains { $0.position == Vector(0,1) })
    }
    
    func testQuery2(){
        let agents = [
            Agent(position: Vector(0,0)),
            Agent(position: Vector(1,0)),
            Agent(position: Vector(2,0)),
            
            Agent(position: Vector(0,1)),
            Agent(position: Vector(1,1)),
            Agent(position: Vector(2,1)),
            
            Agent(position: Vector(0,2)),
            Agent(position: Vector(1,2)),
            Agent(position: Vector(2,2)),
        ]
        
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
}
