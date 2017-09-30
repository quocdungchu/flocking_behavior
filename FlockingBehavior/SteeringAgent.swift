//
//  Agent.swift
//  FlockingBehavior
//
//  Created by Quoc Dung Chu on 9/24/17.
//  Copyright © 2017 quoc. All rights reserved.
//

import Foundation

protocol SteeringAgentDelegate {
    func findSeekingPosition(by agent: SteeringAgent) -> Vect2?
    func findOtherAgentsPositions(within visibleDistance: Float, by agent: SteeringAgent) -> [Vect2]
    func findOtherAgentsVelocities(within visibleDistance: Float, by agent: SteeringAgent) -> [Vect2]
    func canStop(agent: SteeringAgent) -> Bool
}

class SteeringAgent {
    let id: Int
    let behaviors: [SteeringBehavior]
    let maximumSpeed: Float
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
    
    var delegate: SteeringAgentDelegate?
    
    init(
        id: Int,
        behaviors: [SteeringBehavior],
        position: Vect2,
        rotation: Vect2,
        speed: Float,
        maximumSpeed: Float)
    {
        self.id = id
        self.position = position
        self.rotation = rotation
        self.speed = speed
        self.behaviors = behaviors
        self.maximumSpeed = maximumSpeed
    }
    
    private func compute(velocity: Vect2, other: Vect2) -> Vect2 {
        return (velocity + other).limitedVector(maximumLength: maximumSpeed)
    }
    
    private func compute(velocity: Vect2, behaviors: [SteeringBehavior]) -> Vect2 {
        return behaviors.reduce(velocity) {
            compute(velocity: $0, behavior: $1)
        }
    }
    
    private func compute(velocity: Vect2, behavior: SteeringBehavior) -> Vect2 {
        switch behavior {
        case .seeking (let weight, let visibleDistance):
            return compute(
                velocity: velocity,
                other: desiredVelocityForSeeking(
                    weight: weight,
                    boundingDistance: visibleDistance
                )
            )
            
        case .cohesion (let weight, let visibleDistance):
            return compute(
                velocity: velocity,
                other: desiredVelocityForCohesion(
                    weight: weight,
                    boundingDistance: visibleDistance
                )
            )
            
        case .separation (let weight, let visibleDistance):
            return compute(
                velocity: velocity,
                other: desiredVelocityForSeparation(
                    weight: weight,
                    boundingDistance: visibleDistance
                )
            )
            
        case .alignment (let weight, let visibleDistance):
            return compute(
                velocity: velocity,
                other: desiredVelocityForAlignment(
                    weight: weight,
                    boundingDistance: visibleDistance
                )
            )
        }
    }
    
    private func desiredVelocityForSeeking(
        weight: Float,
        boundingDistance: Float) -> Vect2
    {
        if let seekingPosition = delegate?.findSeekingPosition(by: self),
            boundingDistance > position.distance(to: seekingPosition)
        {
            return position.vector(to: seekingPosition) * weight
        } else {
            return Vect2.zero
        }
    }
    
    private func desiredVelocityForCohesion(
        weight: Float,
        boundingDistance: Float) -> Vect2
    {
        if let otherAgentPositions = delegate?.findOtherAgentsPositions(
            within:boundingDistance, by: self)
        {
            return position.vectorToCenter(of: otherAgentPositions) * weight
            
        } else {
            return Vect2.zero
        }
    }
    
    private func desiredVelocityForSeparation(
        weight: Float,
        boundingDistance: Float) -> Vect2
    {
        if let otherAgentPositions = delegate?.findOtherAgentsPositions(
            within:boundingDistance, by: self)
        {
            return position.vectorToCenter(of: otherAgentPositions) * weight * (-1)
            
        } else {
            return Vect2.zero
        }
    }
    
    private func desiredVelocityForAlignment(
        weight: Float,
        boundingDistance: Float) -> Vect2
    {
        if let otherAgentVelocities = delegate?.findOtherAgentsVelocities(
            within:boundingDistance, by: self)
        {
            return average(of: otherAgentVelocities) * weight
            
        } else {
            return Vect2.zero
        }
    }
}

extension SteeringAgent: Updatable {
    func update(_ currentTime: TimeInterval) {
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
}
