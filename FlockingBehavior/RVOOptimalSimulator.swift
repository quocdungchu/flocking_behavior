//
//  RVOOptimalSimulator.swift
//  FlockingBehavior
//
//  Created by Quoc Dung Chu on 01/11/2017.
//  Copyright © 2017 quoc. All rights reserved.
//

import Foundation

class RVOOptimalSimulator {
    
    let timeNoCollision: Double
    let maxNeightborDistance: Float
    let neighborsLeafSize: Int
    var agents = [Agent]()
    var destinations = [Vector]()
    var computeCount: Int = 0
    var agentKTree: AgentKTree!
    
    init(maxNeightborDistance: Float, neighborsLeafSize: Int, timeNoCollision: Double) {
        self.maxNeightborDistance = maxNeightborDistance
        self.neighborsLeafSize = neighborsLeafSize
        self.timeNoCollision = timeNoCollision
    }
    
    func neighbors(of agent: Agent, kTree: AgentKTree) -> [Agent] {
        var neighbors = [Agent]()
        kTree.queryAgents(point: agent.position, range: maxNeightborDistance) {
            neighbors.append($0)
        }
        return neighbors
    }
}

extension RVOOptimalSimulator: RVOSimulator {
    
    func prepareToCompute() {
        agentKTree = AgentKTree(agents: agents, maxLeafSize: neighborsLeafSize)
    }
    
    func neighbors(of agent: Agent) -> [Agent] {
        guard let kTree = agentKTree else {
            return []
        }
        
        return neighbors(of: agent, kTree: kTree)
    }
}
