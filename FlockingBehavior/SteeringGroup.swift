//
//  Group.swift
//  FlockingBehavior
//
//  Created by Quoc Dung Chu on 30/09/2017.
//  Copyright © 2017 quoc. All rights reserved.
//

class SteeringGroup {
    
    private var agents: [SteeringAgent]
    private let destination: Vect2
    private var leader: SteeringAgent?
    
    var isEmpty: Bool {
        return agents.isEmpty
    }
    
    init?(agents: [SteeringAgent], destination: Vect2) {
        guard !agents.isEmpty else {
            return nil
        }
        self.agents = agents
        self.destination = destination
        self.leader = findLeader()
    }
    
    func add(agent: SteeringAgent) {
        if !agents.contains(where: { $0 === agent }) {
            agents.append(agent)
        }
    }
    
    func remove(agent: SteeringAgent) {
        if let index = agents.index(where: { $0 === agent}) {
            agents.remove(at: index)
            self.leader = findLeader()
        }
    }
    
    // TODO find the better method for leader
    private func findLeader() -> SteeringAgent? {
        return agents.first
    }
}
