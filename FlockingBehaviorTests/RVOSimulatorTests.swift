//
//  RVOSimulatorTests.swift
//  FlockingBehaviorTests
//
//  Created by Quoc Dung Chu on 01/11/2017.
//  Copyright © 2017 quoc. All rights reserved.
//

import XCTest
@testable import FlockingBehavior

class RVOSimulatorTests: XCTestCase {
    
    func testBuilderTwoAgentsInCircle(){
        let simulator = RVOSimpleSimulator(timeNoCollision: 10.0)
        simulator.addAgentInCircle(radius: 5.0, numberOfAgents: 2, agentRadius: 1.0, agentMaxSpeed: 1.0)
        
        XCTAssertTrue(simulator.agents[0].position.isEqualInProximity(to: Vector(5.0, 0.0)))
        XCTAssertTrue(simulator.destinations[0].isEqualInProximity(to: Vector(-5.0, 0.0)))
        
        XCTAssertTrue(simulator.agents[1].position.isEqualInProximity(to: Vector(-5.0, 0.0)))
        XCTAssertTrue(simulator.destinations[1].isEqualInProximity(to: Vector(5.0, 0.0)))
    }
    
    func testBuilderFourAgentsInCircle(){
        let simulator = RVOSimpleSimulator(timeNoCollision: 10.0)
        simulator.addAgentInCircle(radius: 5.0, numberOfAgents: 4, agentRadius: 1.0, agentMaxSpeed: 1.0)
        
        XCTAssertTrue(simulator.agents[0].position.isEqualInProximity(to: Vector(5.0, 0.0)))
        XCTAssertTrue(simulator.destinations[0].isEqualInProximity(to: Vector(-5.0, 0.0)))
        
        XCTAssertTrue(simulator.agents[1].position.isEqualInProximity(to: Vector(0.0, 5.0)))
        XCTAssertTrue(simulator.destinations[1].isEqualInProximity(to: Vector(0.0, -5.0)))
        
        XCTAssertTrue(simulator.agents[2].position.isEqualInProximity(to: Vector(-5.0, 0.0)))
        XCTAssertTrue(simulator.destinations[2].isEqualInProximity(to: Vector(5.0, 0.0)))
        
        XCTAssertTrue(simulator.agents[3].position.isEqualInProximity(to: Vector(0.0, -5.0)))
        XCTAssertTrue(simulator.destinations[3].isEqualInProximity(to: Vector(0.0, 5.0)))
    }
}
