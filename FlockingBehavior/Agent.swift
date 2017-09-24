//
//  Agent.swift
//  FlockingBehavior
//
//  Created by Quoc Dung Chu on 9/24/17.
//  Copyright © 2017 quoc. All rights reserved.
//

import Foundation

protocol AgentDelegate {
    func findSeekingPosition(by agent: Agent) -> Vect2?
    func findOtherAgentsPositions(within visibleDistance: Float, by agent: Agent) -> [Vect2]
    func findOtherAgentsVelocities(within visibleDistance: Float, by agent: Agent) -> [Vect2]
    func canStop(agent: Agent) -> Bool
}

class Agent {
    let behaviors: [Behavior]
    let maximumSpeed: Float
    let minimumSpeed: Float
    var position: Vect2
    var rotation: Vect2
    var speed: Float
    var velocity: Vect2 {
        get {
            return rotation.normalized * speed
        }
        
        set {
            rotation = newValue.normalized
            speed = newValue.length
        }
    }
    
    var delegate: AgentDelegate?
    
    init(
        behaviors: [Behavior],
        position: Vect2,
        rotation: Vect2,
        speed: Float,
        maximumSpeed: Float,
        minimumSpeed: Float)
    {
        self.position = position
        self.rotation = rotation
        self.speed = speed
        self.behaviors = behaviors
        self.maximumSpeed = maximumSpeed
        self.minimumSpeed = minimumSpeed
    }
    
    func update(){
        guard let delegate = delegate else {
            return
        }
        
        if delegate.canStop(agent: self) {
            speed = 0
        } else {
            let newVelocity = compute(velocity: velocity, behaviors: behaviors)
            velocity = newVelocity
            position += velocity
        }
    }
    
    private func compute(velocity: Vect2, other: Vect2) -> Vect2 {
        let newVelocity = velocity + other
        return clamp(velocity: newVelocity)
    }
    
    
    private func compute(velocity: Vect2, behaviors: [Behavior]) -> Vect2 {
        return behaviors.reduce(velocity) {
            compute(velocity: $0, behavior: $1)
        }
    }
    
    private func compute(velocity: Vect2, behavior: Behavior) -> Vect2 {
        switch behavior {
        case .seeking (let weight, let visibleDistance):
            return compute(
                velocity: velocity,
                other: calculateSeeking(
                    weight: weight,
                    visibleDistance: visibleDistance
                )
            )
            
        case .cohesion (let weight, let visibleDistance):
            return compute(
                velocity: velocity,
                other: calculateCohesion(
                    weight: weight,
                    visibleDistance: visibleDistance
                )
            )
            
        case .separation (let weight, let visibleDistance):
            return compute(
                velocity: velocity,
                other: calculateSeparation(
                    weight: weight,
                    visibleDistance: visibleDistance
                )
            )
            
        case .alignment (let weight, let visibleDistance):
            return compute(
                velocity: velocity,
                other: calculateAlignment(
                    weight: weight,
                    visibleDistance: visibleDistance
                )
            )
        }
    }
    
    private func calculateSeeking(
        weight: Float,
        visibleDistance: Float) -> Vect2
    {
        if let seekingPosition = delegate?.findSeekingPosition(by: self),
            visibleDistance > position.distance(to: seekingPosition)
        {
            return vectorTo(point: seekingPosition) * weight
        } else {
            return Vect2.zero
        }
    }
    
    private func calculateCohesion(
        weight: Float,
        visibleDistance: Float) -> Vect2
    {
        if let otherAgentPositions = delegate?.findOtherAgentsPositions(
            within:visibleDistance, by: self)
        {
            let vectorToCenter = vectorToCenterPoint(of: otherAgentPositions)
            return vectorToCenter * weight
            
        } else {
            return Vect2.zero
        }
    }
    
    private func calculateSeparation(
        weight: Float,
        visibleDistance: Float) -> Vect2
    {
        if let otherAgentPositions = delegate?.findOtherAgentsPositions(
            within:visibleDistance, by: self)
        {
            let vectorToCenter = vectorToCenterPoint(of: otherAgentPositions) * (-1)
            return vectorToCenter * weight
            
        } else {
            return Vect2.zero
        }
    }
    
    private func calculateAlignment(
        weight: Float,
        visibleDistance: Float) -> Vect2
    {
        if let otherAgentVelocities = delegate?.findOtherAgentsVelocities(
            within:visibleDistance, by: self)
        {
            let averageVelocity = average(of: otherAgentVelocities)
            return averageVelocity * weight
            
        } else {
            return Vect2.zero
        }
    }
        
    
    private func clamp(velocity: Vect2) -> Vect2 {
        let speed = velocity.length
        if speed > maximumSpeed {
            return velocity.normalized * maximumSpeed
            
        } else {
            return velocity
        }
    }
    
    private func vectorToCenterPoint(of points: [Vect2]) -> Vect2 {
        return points.isEmpty ?
            Vect2.zero:
            vectorTo(point: average(of: points))
    }
    
    private func vectorTo(point: Vect2) -> Vect2 {
        return point - position
    }
}
