//
//  RVOSimulator.swift
//  FlockingBehavior
//
//  Created by Quoc Dung Chu on 30/10/2017.
//  Copyright © 2017 quoc. All rights reserved.
//

import Foundation

class RVOSimpleSimulator {
    
    let timeNoCollision: Double
    let timeStep: Double
    
    var agents = [Agent]()
    var destinations = [Vector]()
    
    var globalTime: Int = 0
    
    var agentKTree: AgentKTree!
    
    init(timeNoCollision: Double, timeStep: Double) {
        self.timeNoCollision = timeNoCollision
        self.timeStep = timeStep
    }
    
    func add(agent: Agent, destination: Vector) {
        agents.append(agent)
        destinations.append(destination)
    }
    
    func removeAll() {
        agents.removeAll()
        destinations.removeAll()
    }
    
    func computeAgents(timeStep: Double){
        
        var computedVelocities = [Vector]()
        
        for i in 0..<agents.count {
            let agent = agents[i]
            let destination = destinations[i]
            
            let agentNeighbors = neighbors(of: agent)
            
            let agentComputed = agent.computedVelocity(
                preferredVelocity: preferredVelocity(of: agent, destination: destination),
                neighbors: agentNeighbors,
                timeNoCollision: timeNoCollision,
                timeStep: timeStep
            )
            
            computedVelocities.append(agentComputed)
        }
        
        for i in 0..<agents.count {
            agents[i].update(computedVelocity: computedVelocities[i], timeStep: timeStep)
        }
        
        globalTime += 1
    }
    
    func neighbors(of agent: Agent) -> [Agent] {
        return agents.filter { $0 !== agent }
    }
    
    func preferredVelocity(of agent: Agent, destination: Vector) -> Vector {
        let relativePosition = destination - agent.position
        
        if relativePosition.length > 1 {
            return relativePosition.normalized
            
        } else {
            return relativePosition
        }
    }
    
    func printVisualisationForDebug(){
        var positionString = "\(globalTime)"
        agents.forEach {
            positionString += " (\(String(format:"%.6f", $0.position.x)), \(String(format:"%.6f", $0.position.y)))"
        }
        print("\(positionString)")
    }
}

extension RVOSimpleSimulator {
    enum Constants {
        static let agentRadius: Float = 1.0
        static let agentMaxSpeed: Float = 0.5
        static let timeNoCollision: Double = 2
        static let timeStep: Double = 0.5
    }
    
    static func makeWithAgentsInCircle(
        radius: Float,
        numberOfAgents: Int,
        agentRadius: Float = Constants.agentRadius,
        agentMaxSpeed: Float = Constants.agentMaxSpeed,
        timeNoCollision: Double = Constants.timeNoCollision,
        timeStep: Double = Constants.timeStep) -> RVOSimpleSimulator
    {
        let simulator = RVOSimpleSimulator(
            timeNoCollision: timeNoCollision,
            timeStep: timeStep
        )
    
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
            simulator.add(agent: agent, destination: destination)
        }
        
        return simulator
    }
}
