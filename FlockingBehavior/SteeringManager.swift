//
//  SteeringManager.swift
//  FlockingBehavior
//
//  Created by Quoc Dung Chu on 27/09/2017.
//  Copyright © 2017 quoc. All rights reserved.
//
import Foundation

class SteeringManager {
    
    fileprivate var agents = [SteeringAgent]()
    
    private var groups = [SteeringGroup]()
    
    func add(agent: SteeringAgent) {
        if !agents.contains(where: { $0 === agent }) {
            agents.append(agent)
        }
    }
    
    func remove(agent: SteeringAgent) {
        if let index = agents.index(where: { $0 === agent}) {
            agents.remove(at: index)
        }
    }
    
    func move(agents: [SteeringAgent], to destination: Vect2) {
        if let group = SteeringGroup(agents: agents, destination: destination) {
            groups.append(group)
        }
    }
    
    func update(_ currentTime: TimeInterval) {
        self.groups = groups.filter { !$0.isEmpty }
    }
}

extension SteeringManager: SteeringAgentDelegate {
    func findSeekingPosition(by agent: SteeringAgent) -> Vect2? {
        return Vect2.zero
    }
    
    func findOtherAgentsPositions(within visibleDistance: Float, by agent: SteeringAgent) -> [Vect2] {
        return []
    }
    
    func findOtherAgentsVelocities(within visibleDistance: Float, by agent: SteeringAgent) -> [Vect2] {
        return []
    }
    
    func canStop(agent: SteeringAgent) -> Bool {
        return true
    }
}
