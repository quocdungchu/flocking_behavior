//
//  SteeringManager.swift
//  FlockingBehavior
//
//  Created by Quoc Dung Chu on 27/09/2017.
//  Copyright © 2017 quoc. All rights reserved.
//
import Foundation

class SteeringManager {
    
    private var agents = [Int: SteeringAgent]()
    private var groups = [SteeringGroup]()
    
    func move(agents: [SteeringAgent], to destination: Vect2) {
        if let group = SteeringGroup(
            id: UUID().hashValue,
            agents: agents,
            destination: destination)
        {
            
            for agent in agents {
                if let oldGroup = findGroupThatContains(agent: agent) {
                    oldGroup.remove(agent: agent)
                }
                agent.groupDelegate = group
            }
            
            groups.append(group)
        }
    }
    
    func add(agent: SteeringAgent) {
        self.agents[agent.id] = agent
    }
    
    func remove(agent: SteeringAgent) {
        self.agents.removeValue(forKey: agent.id)
    }
    
    private func findGroupThatContains(agent: SteeringAgent) -> SteeringGroup? {
        return groups.first(where: {
            $0.contain(agent: agent)
        })
    }
}

extension SteeringManager: Updatable {
    func update(_ currentTime: TimeInterval) {
        self.groups = groups.filter { !$0.hasAchievedToDestination }
        
        groups.forEach { $0.update(currentTime) }
    }
}
