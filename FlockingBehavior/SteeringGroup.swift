//
//  Group.swift
//  FlockingBehavior
//
//  Created by Quoc Dung Chu on 30/09/2017.
//  Copyright © 2017 quoc. All rights reserved.
//

import Foundation

class SteeringGroup {
    private let id: Int
    private var agents: [Int: SteeringAgent]
    private let destination: Vect2
    private var leader: SteeringAgent?
    
    var isEmpty: Bool {
        return agents.isEmpty
    }
    
    init?(id: Int, agents: [SteeringAgent], destination: Vect2) {
        guard !agents.isEmpty else {
            return nil
        }
        self.id = id
        
        var theAgents = [Int: SteeringAgent]()
        agents.forEach { theAgents[$0.id] = $0 }
        self.agents = theAgents
        
        self.destination = destination
        self.leader = findLeader()
    }
    
    func add(agent: SteeringAgent) {
        self.agents[agent.id] = agent
    }
    
    func remove(agent: SteeringAgent) {
        self.agents.removeValue(forKey: agent.id)
        self.leader = findLeader()
    }
    
    func contain(agent: SteeringAgent) -> Bool {
        return agents[agent.id] != nil
    }
    
    // TODO find the better method for leader
    private func findLeader() -> SteeringAgent? {
        return agents.first?.value
    }
}

extension SteeringGroup: Updatable {
    func update(_ currentTime: TimeInterval) {
        agents.forEach { $1.update(currentTime) }
    }
}
