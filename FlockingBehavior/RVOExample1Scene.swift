//
//  RVOScene.swift
//  FlockingBehavior
//
//  Created by Quoc Dung Chu on 29/10/2017.
//  Copyright © 2017 quoc. All rights reserved.
//

import UIKit
import SpriteKit

class RVOExample1Scene: SKScene {
    
    let noCollisionDeltaTime = 8.0
    let timeStep = 1.0
    let agentDestination = Vector(-5.0, 0)
    let neightborDestination = Vector(5.0, 0)
    
    var agentNode: RVOAgentNode!
    var neighborNode: RVOAgentNode!
    var agentAvoidanceNode: RVOAvoidanceNode!
    
    override func didMove(to view: SKView) {
        
        agentNode = RVOAgentNode(agent: Agent(position: Vector(5.0, 0.0), radius: 1.0, maxSpeed: 0.5))
        neighborNode = RVOAgentNode(agent: Agent(position: Vector(-5.0, 0.0), radius: 1.0, maxSpeed: 0.5))
        agentAvoidanceNode = RVOAvoidanceNode(agent: agentNode.agent, neighbors: [neighborNode.agent], noCollisionDeltaTime: noCollisionDeltaTime)

        addChild(agentNode)
        addChild(neighborNode)
        addChild(agentAvoidanceNode)

    }
    
    func nextStep(){
        let agent = agentNode.agent
        let neighbor = neighborNode.agent
        
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
        
        agentNode.update()
        neighborNode.update()
        agentAvoidanceNode.update()
    }
}
