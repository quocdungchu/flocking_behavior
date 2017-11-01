//
//  RVOSimulator.swift
//  FlockingBehavior
//
//  Created by Quoc Dung Chu on 30/10/2017.
//  Copyright © 2017 quoc. All rights reserved.
//

import Foundation

class RVOSimulator {
    
    let noCollisionDeltaTime: Double
    let timeStep: Double
    
    var agents = [Agent]()
    var destinations = [Vector]()
    
    init(noCollisionDeltaTime: Double, timeStep: Double) {
        self.noCollisionDeltaTime = noCollisionDeltaTime
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
    
    func computeAgents(){
        var computedVelocities = [Vector]()
        
        for i in 0..<agents.count {
            let agent = agents[i]
            let destination = destinations[i]
            let neighbors = agents.filter { $0 !== agent }
            
            let agentComputed = agent.computedVelocity(
                preferredVelocity: (destination - agent.position).limitedVector(maximumLength: agent.maxSpeed),
                neighbors: neighbors,
                noCollisionDeltaTime: noCollisionDeltaTime,
                timeStep: timeStep
            )
            
            computedVelocities.append(agentComputed)
        }
        
        for i in 0..<agents.count {
            agents[i].update(computedVelocity: computedVelocities[i], timeStep: timeStep)
        }
    }
}

extension RVOSimulator {
    enum Constants {
        static let agentRadius: Float = 1.0
        static let agentMaxSpeed: Float = 0.5
        static let noCollisionDeltaTime: Double = 2
        static let timeStep: Double = 0.5
    }
    
    static func makeWithAgentsInCircle(
        radius: Float,
        numberOfAgents: Int,
        agentRadius: Float = Constants.agentRadius,
        agentMaxSpeed: Float = Constants.agentMaxSpeed,
        noCollisionDeltaTime: Double = Constants.noCollisionDeltaTime,
        timeStep: Double = Constants.timeStep) -> RVOSimulator
    {
        let simulator = RVOSimulator(
            noCollisionDeltaTime: noCollisionDeltaTime,
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
