//
//  RVOSimulator.swift
//  FlockingBehavior
//
//  Created by Quoc Dung Chu on 04/11/2017.
//  Copyright © 2017 quoc. All rights reserved.
//

import Foundation

protocol RVOSimulator {
    func add(agent: Agent, destination: Vector)
    func removeAll()
    func computeAgents(timeStep: Double)
    func neighbors(of agent: Agent) -> [Agent]
    func printVisualisationForDebug()
}

extension RVOSimulator {
    func addAgentInCircle(
        radius: Float,
        numberOfAgents: Int,
        agentRadius: Float,
        agentMaxSpeed: Float)
    {
        let angleBetweenTwoAgents = 2.0 * Float.pi / Float(numberOfAgents)
        
        for i in 0..<numberOfAgents {
            let angle = angleBetweenTwoAgents * Float(i)
            let agentPosition = Vector(radius * cos(angle), radius * sin(angle))
            let agent = Agent(
                position: agentPosition,
                radius: agentRadius,
                maxSpeed: agentMaxSpeed
            )
            let destination = -1 * agentPosition
            add(agent: agent, destination: destination)
        }
    }
    
    func preferredVelocity(of agent: Agent, destination: Vector) -> Vector {
        let relativePosition = destination - agent.position
        
        if relativePosition.length > 1 {
            return relativePosition.normalized
            
        } else {
            return relativePosition
        }
    }
}
