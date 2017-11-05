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
    
    var agents = [Agent]()
    var destinations = [Vector]()
    
    var globalTime: Int = 0
    
    var agentKTree: AgentKTree!
    
    init(timeNoCollision: Double) {
        self.timeNoCollision = timeNoCollision
    }
}

extension RVOSimpleSimulator: RVOSimulator {
    
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
    
    func printVisualisationForDebug(){
        var positionString = "\(globalTime)"
        agents.forEach {
            positionString += " (\(String(format:"%.6f", $0.position.x)), \(String(format:"%.6f", $0.position.y)))"
        }
        print("\(positionString)")
    }
}
