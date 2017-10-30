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
        let noCollisionDeltaTime = 2.0
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
            noCollisionDeltaTime: noCollisionDeltaTime,
            timeStep: timeStep
        )
        
        XCTAssertNotNil(orcaLine)
        XCTAssertEqual(orcaLine!.direction, Vector(0, -1))
    }
    
    func testAvoidanceCollision(){
        let noCollisionDeltaTime = 8.0
        let timeStep = 1.0
        let agentDestination = Vector(-5.0, 0)
        let neightborDestination = Vector(5.0, 0)

        let agent = Agent(
            position: Vector(5.0, 0.0),
            radius: 1.0,
            maxSpeed: 0.5,
            velocity: Vector(-0.5, 0.0)
        )
        
        let neighbor = Agent(
            position: Vector(-5.0, 0.0),
            radius: 1.0,
            maxSpeed: 0.5,
            velocity: Vector(0.5, 0.0)
        )
        
        var isCollided = false
        
        for _ in 0...100 {
            let agentComputed = agent.computedVelocity(
                preferredVelocity: (agentDestination - agent.position).limitedVector(maximumLength: agent.maxSpeed),
                neighbors: [neighbor],
                noCollisionDeltaTime: noCollisionDeltaTime,
                timeStep: timeStep
            )
            
            let neighborComputed = neighbor.computedVelocity(
                preferredVelocity: (neightborDestination - neighbor.position).limitedVector(maximumLength: neighbor.maxSpeed),
                neighbors: [agent],
                noCollisionDeltaTime: noCollisionDeltaTime,
                timeStep: timeStep
            )
            
            agent.update(computedVelocity: agentComputed, timeStep: timeStep)
            neighbor.update(computedVelocity: neighborComputed, timeStep: timeStep)

            isCollided = isCollided || (agent.position - neighbor.position).length - (agent.radius + neighbor.radius) < RVOConstants.epsilon
        }
        
        XCTAssertFalse(isCollided)
    }
}
