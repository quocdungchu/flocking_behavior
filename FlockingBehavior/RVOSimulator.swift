//
//  RVOSimulator.swift
//  FlockingBehavior
//
//  Created by Quoc Dung Chu on 04/11/2017.
//  Copyright © 2017 quoc. All rights reserved.
//

import Foundation

struct RVOSimulatorBlockDefinition {
    let numberAgentInHorizontal: Int
    let numberAgentInVertical: Int
    let distanceBetweenAgent: Float
}

struct RVOSimulatorAgentDefinition {
    let radius: Float
    let maxSpeed: Float
}

enum RVOAgentBehavior {
    case idle
    case goal(to: Vector)
}

protocol RVOSimulator: class {
    var timeNoCollision: Double { get }
    var agents: [Agent] { get set }
    var destinations: [Vector] { get set }
    var behaviors: [RVOAgentBehavior] { get set }
    var computeCount: Int { get set }

    func prepareToCompute()
    func neighbors(of agent: Agent) -> [Agent]
}

extension RVOSimulator {
    
    func computeAgents(timeStep: Double){
        prepareToCompute()
        
        var computedVelocities = [Vector]()
        
        for i in 0..<agents.count {
            let agent = agents[i]
            let behavior = behaviors[i]
            
            let agentNeighbors = neighbors(of: agent)
            
            let agentComputed = agent.computedVelocity(
                preferredVelocity: preferredVelocity(of: agent, behavior: behavior),
                neighbors: agentNeighbors,
                timeNoCollision: timeNoCollision,
                timeStep: timeStep
            )
            
            computedVelocities.append(agentComputed)
        }
        
        for i in 0..<agents.count {
            agents[i].update(computedVelocity: computedVelocities[i], timeStep: timeStep)
        }
        
        for i in 0..<agents.count {
            switch behaviors[i] {
            case .idle:
                break
                
            case .goal(let to):
                if (agents[i].position - to).length <= RVOConstants.epsilon {
                    behaviors[i] = .idle
                }
            }
        }
        
        computeCount += 1
    }
    
    func add(agent: Agent, destination: Vector) {
        agents.append(agent)
        destinations.append(destination)
        behaviors.append(.goal(to: destination))
    }
    
    func removeAll() {
        agents.removeAll()
        destinations.removeAll()
    }
    
    private func preferredVelocity(of agent: Agent, behavior: RVOAgentBehavior) -> Vector {
        
        switch behavior {
        case .idle:
            return Vector.zero
            
        case .goal(let to):
            let relativePosition = to - agent.position
            
            if relativePosition.length > 1 {
                return relativePosition.normalized
                
            } else {
                return relativePosition
            }
        }
    }
    
    func printVisualisationForDebug(){
        var positionString = "\(computeCount)"
        agents.forEach {
            positionString += " (\(String(format:"%.6f", $0.position.x)), \(String(format:"%.6f", $0.position.y)))"
        }
        print("\(positionString)")
    }
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
    
    func addAgentInBlockAndOneDestination(
        blockDefinition: RVOSimulatorBlockDefinition,
        agentDefinition: RVOSimulatorAgentDefinition,
        agentBlockPositions: [Vector],
        destination: Vector)
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
                    
                    add(agent: agent, destination: destination)
                }
            }
        }
    }
}
