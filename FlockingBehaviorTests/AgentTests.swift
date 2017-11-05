//
//  AgentOCRALineTests.swift
//  FlockingBehaviorTests
//
//  Created by Quoc Dung Chu on 29/10/2017.
//  Copyright © 2017 quoc. All rights reserved.
//

import XCTest
@testable import FlockingBehavior

class AgentTests: XCTestCase {
    func testOCRALine(){
        let timeNoCollision = 2.0
        let timeStep = 0.25
        
        let agent = Agent(
            position: Vector(5.0, 0.0),
            radius: 1.0,
            maxSpeed: 0.5,
            velocity: Vector(-0.5, 0.0)
        )
        
        let neighbor = Agent(
            position: Vector(0.0, 0.0),
            radius: 1.0,
            maxSpeed: 0.0,
            velocity: Vector(0.0, 0.0)
        )
        
        let orcaLine = agent.orcaLine(
            preferredVelocity: Vector(-0.5, 0.0),
            neighbor: neighbor,
            timeNoCollision: timeNoCollision,
            timeStep: timeStep
        )
        
        XCTAssertNotNil(orcaLine)
        XCTAssertEqual(orcaLine!.direction, Vector(0, -1))
    }
    
    func testAvoidanceCollisionTwoAgent1(){
        let simulator = RVOSimpleSimulator(timeNoCollision: 25.0)
        simulator.add(
            agent: Agent(
                position: Vector(5.0, 0.0),
                radius: 1.0,
                maxSpeed: 0.5,
                velocity: Vector(-0.5, 0.0)
            ),
            destination: Vector(-5.0, 0)
        )
        
        simulator.add(
            agent: Agent(
                position: Vector(-5.0, 0.0),
                radius: 1.0,
                maxSpeed: 0.5,
                velocity: Vector(0.5, 0.0)
            ),
            destination: Vector(5.0, 0)
        )
        
        var isCollided = false
        
        for _ in 0...100 {
            simulator.computeAgents(timeStep: 1.0)
            isCollided = isCollided || simulator.isCollided
        }
        
        XCTAssertFalse(isCollided)
        XCTAssertTrue(simulator.isAchieved)
    }
    
    func testAvoidanceCollisionTwoAgent2(){
        let simulator = RVOSimpleSimulator(timeNoCollision: 25.0)
        simulator.add(
            agent: Agent(
                position: Vector(5.0, 0.0),
                radius: 1.0,
                maxSpeed: 0.5,
                velocity: Vector(-0.5, 0.0)
            ),
            destination: Vector(-5.0, 0)
        )
        
        simulator.add(
            agent: Agent(
                position: Vector(0.0, 0.0),
                radius: 1.0,
                maxSpeed: 0.0,
                velocity: Vector(0.0, 0.0)
            ),
            destination: Vector(0.0, 0)
        )
        
        var isCollided = false
        
        for _ in 0...100 {
            simulator.computeAgents(timeStep: 1.0)
            isCollided = isCollided || simulator.isCollided
        }
        
        XCTAssertFalse(isCollided)
        XCTAssertTrue(simulator.isAchieved)
    }
    
    func testAvoidanceCollisionEightAgent(){
        let simulator = RVOSimpleSimulator(timeNoCollision: 25.0)
        simulator.addAgentInCircle(radius: 5.0, numberOfAgents: 5, agentRadius: 1.0, agentMaxSpeed: 1.0)
        
        var isCollided = false
        
        for _ in 0...200 {
            simulator.computeAgents(timeStep: 1.0)
            isCollided = isCollided || simulator.isCollided
        }
        
        XCTAssertFalse(isCollided)
        XCTAssertTrue(simulator.isAchieved)
    }
}

extension RVOSimulator {
    var isCollided: Bool {
        var isCollided = false
        for i in 0..<agents.count {
            for j in (i+1)..<agents.count {
                let distance = (agents[i].position - agents[j].position).length
                let totalRadius = agents[i].radius + agents[j].radius

                isCollided = isCollided || distance - totalRadius <= RVOConstants.epsilon
            }
        }
        return isCollided
    }
    
    var isAchieved: Bool {
        var isAchieved = true
        for i in 0..<agents.count {
            isAchieved = isAchieved && agents[i].position.isEqualInProximity(to: destinations[i])
        }
        return isAchieved
    }
}

extension Vector {
    func isEqualInProximity(to vector: Vector) -> Bool {
        return fabs(x - vector.x) <= RVOConstants.epsilon && fabs(y - vector.y) <= RVOConstants.epsilon
    }
}
