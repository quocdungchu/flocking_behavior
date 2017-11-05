//
//  RVOSimulator.swift
//  FlockingBehavior
//
//  Created by Quoc Dung Chu on 04/11/2017.
//  Copyright © 2017 quoc. All rights reserved.
//

import Foundation

protocol RVOSimulator: class {
    var agents: [Agent] { get set }
    var destinations: [Vector] { get set }

    func computeAgents(timeStep: Double)
    func neighbors(of agent: Agent) -> [Agent]
    func printVisualisationForDebug()
}

struct RVOSimulatorBlockDefinition {
    let numberAgentInHorizontal: Int
    let numberAgentInVertical: Int
    let distanceBetweenAgent: Float
}

struct RVOSimulatorAgentDefinition {
    let radius: Float
    let maxSpeed: Float
}

extension RVOSimulator {
    
    func add(agent: Agent, destination: Vector) {
        agents.append(agent)
        destinations.append(destination)
    }
    
    func removeAll() {
        agents.removeAll()
        destinations.removeAll()
    }
    
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
    
    func addAgentInBlock(
        blockDefinition: RVOSimulatorBlockDefinition,
        agentDefinition: RVOSimulatorAgentDefinition,
        agentBlockPositions: [Vector],
        destinationBlockPositions: [Vector])
    {
        for i in 0..<blockDefinition.numberAgentInHorizontal {
            for j in 0..<blockDefinition.numberAgentInVertical {
                for k in 0..<agentBlockPositions.count {
                    let positionInBlock = Vector(Float(i) * blockDefinition.distanceBetweenAgent, Float(j) * blockDefinition.distanceBetweenAgent)
                    
                    let agentPosition = agentBlockPositions[k] + positionInBlock
                    
                    let agent = Agent(
                        position: agentPosition,
                        radius: agentDefinition.radius,
                        maxSpeed: agentDefinition.maxSpeed
                    )
                    
                    let destinationPosition = destinationBlockPositions[k] + positionInBlock
                    
                    add(agent: agent, destination: destinationPosition)
                }
            }
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
