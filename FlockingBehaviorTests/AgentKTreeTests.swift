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
    
    func test_buildNodes_withThreeAents(){
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
}
