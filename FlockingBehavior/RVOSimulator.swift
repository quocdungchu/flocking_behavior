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
    
    func computeAgents(){
        var computedVelocities = [Vector]()
        
        for i in 0..<agents.count {
            let agent = agents[i]
            let destination = destinations[i]
            let neighbors = agents.enumerated()
                .filter { (index, _) in index != i }
                .map { $1 }
            
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
