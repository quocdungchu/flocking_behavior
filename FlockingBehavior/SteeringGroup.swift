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
    private var achievedAgent: [Int: SteeringAgent]
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
        
        self.achievedAgent = [Int: SteeringAgent]()
        self.destination = destination
        self.leader = findLeader()
    }
    
    func remove(agent: SteeringAgent) {
        self.agents.removeValue(forKey: agent.id)
        self.leader = findLeader()
    }
    
    func contain(agent: SteeringAgent) -> Bool {
        return agents[agent.id] != nil
    }
    
    fileprivate func markAsAchieved(agent: SteeringAgent) {
        achievedAgent[agent.id] = agent
    }
    
    fileprivate func isMarkedAsAchieved(agent: SteeringAgent) -> Bool {
        return achievedAgent[agent.id] != nil
    }
    
    // TODO find the better method for leader
    private func findLeader() -> SteeringAgent? {
        return agents.first?.value
    }
    
    private func findOtherAgents(
        by agent: SteeringAgent,
        boundingDistance: Float) -> [SteeringAgent]
    {
        return agents.values
            .filter { $0 !== agent }
            .filter { $0.position.distance(to: agent.position) <= boundingDistance }
    }
    
    fileprivate func findOtherAgentPositions(
        by agent: SteeringAgent,
        boundingDistance: Float) -> [Vect2]
    {
        return findOtherAgents(by: agent, boundingDistance: boundingDistance)
            .map { $0.position }
    }
    
    fileprivate func findOtherAgentVelocities(
        by agent: SteeringAgent,
        boundingDistance: Float) -> [Vect2]
    {
        return findOtherAgents(by: agent, boundingDistance: boundingDistance)
            .map { $0.velocity }
    }
}

extension SteeringGroup: Updatable {
    func update(_ currentTime: TimeInterval) {
        agents.forEach { $1.update(currentTime) }
    }
}

extension SteeringGroup: SteeringAgentGroupDelegate {
    
    func findSeekingPosition(by agent: SteeringAgent, boundingDistance: Float) -> Vect2? {
        if agent.position.distance(to: destination) <= boundingDistance
        {
            return destination
            
        } else {
            return nil
        }
    }
    
    func findOtherAgentPositionsForCohesion(
        by agent: SteeringAgent,
        boundingDistance: Float) -> [Vect2]
    {
        return findOtherAgentPositions(by: agent, boundingDistance: boundingDistance)
    }
    
    func findOtherAgentPositionsForSeparation(
        by agent: SteeringAgent,
        boundingDistance: Float) -> [Vect2]
    {
        return findOtherAgentPositions(by: agent, boundingDistance: boundingDistance)
    }
    
    func findOtherAgentVelocitiesForAlignment(
        by agent: SteeringAgent,
        boundingDistance: Float) -> [Vect2]
    {
        return findOtherAgentVelocities(by: agent, boundingDistance: boundingDistance)
    }
    
    func validateToAchieve(agent: SteeringAgent) {
        if agent.position.distance(to: destination) <= MaximumDistanceToStop {
            markAsAchieved(agent: agent)
        }
    }
    
    func isGroupLeader(agent: SteeringAgent) -> Bool {
        return agent === leader
    }
    
    func hasAchieved(agent: SteeringAgent) -> Bool {
        return isMarkedAsAchieved(agent: agent)
    }
}
