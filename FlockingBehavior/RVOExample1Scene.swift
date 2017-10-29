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
    let agentNode = RVOAgentNode(agent: Agent(position: Vector(5.0, 0.0), radius: 1.0, maxSpeed: 0.5))
    let neighborNode = RVOAgentNode(agent: Agent(position: Vector(-5.0, 0.0), radius: 1.0, maxSpeed: 0.5))
    
    override func didMove(to view: SKView) {
        addChild(agentNode)
        addChild(neighborNode)
    }
    
    func nextStep(){
        let agent = agentNode.agent
        let neighbor = neighborNode.agent
        
        agent.update(
            preferredVelocity: (agentDestination - agent.position).limitedVector(maximumLength: agent.maxSpeed),
            neighbors: [neighbor],
            noCollisionDeltaTime: noCollisionDeltaTime,
            timeStep: timeStep
        )
        
        neighbor.update(
            preferredVelocity: (neightborDestination - neighbor.position).limitedVector(maximumLength: neighbor.maxSpeed),
            neighbors: [agent],
            noCollisionDeltaTime: noCollisionDeltaTime,
            timeStep: timeStep
        )
        
        agentNode.update()
        neighborNode.update()
    }
}
