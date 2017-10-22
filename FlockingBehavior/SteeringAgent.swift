//
//  Agent.swift
//  FlockingBehavior
//
//  Created by Quoc Dung Chu on 9/24/17.
//  Copyright © 2017 quoc. All rights reserved.
//

import Foundation

protocol SteeringAgenetBehaviorsDataSource: class {
    func behaviors(of agent: SteeringAgent, isGroupLeader: Bool, hasAchieved: Bool) -> [SteeringBehavior]
}

protocol SteeringAgentGroupDelegate: class {
    func findSeekingPosition(by agent: SteeringAgent, boundingDistance: Float) -> Vector?
    func findOtherAgentPositionsForCohesion(by agent: SteeringAgent, boundingDistance: Float) -> [Vector]
    func findOtherAgentPositionsForSeparation(by agent: SteeringAgent, boundingDistance: Float) -> [Vector]
    func findOtherAgentVelocitiesForAlignment(by agent: SteeringAgent, boundingDistance: Float) -> [Vector]
    func validateToAchieve(agent: SteeringAgent)
    func isGroupLeader(agent: SteeringAgent) -> Bool
    func hasAchieved(agent: SteeringAgent) -> Bool
}

protocol SteeringAgentUpdatingDelegate: class {
    func willAgentUpdate(agent: SteeringAgent)
    func didAgentUpdate(agent: SteeringAgent)
}

class SteeringAgent {
    let id: Int
    private let maximumSpeed: Float
    var position: Vector
    var rotation: Vector
    var speed: Float
    var velocity: Vector {
        get {
            return rotation.normalized * speed
        }
        
        set {
            rotation = newValue.normalized
            speed = newValue.length
        }
    }
    
    weak var behaviorsDataSource: SteeringAgenetBehaviorsDataSource?
    weak var updatingDelegate: SteeringAgentUpdatingDelegate?
    weak var groupDelegate: SteeringAgentGroupDelegate?

    init(
        id: Int,
        position: Vector,
        rotation: Vector,
        speed: Float,
        maximumSpeed: Float)
    {
        self.id = id
        self.position = position
        self.rotation = rotation
        self.speed = speed
        self.maximumSpeed = maximumSpeed
    }
    
    private func compute(velocity: Vector, other: Vector) -> Vector {
        return (velocity + other).limitedVector(maximumLength: maximumSpeed)
    }
    
    private func compute(velocity: Vector, behaviors: [SteeringBehavior]) -> Vector {
        return behaviors.reduce(velocity) {
            compute(velocity: $0, behavior: $1)
        }
    }
    
    private func compute(velocity: Vector, behavior: SteeringBehavior) -> Vector {
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
        boundingDistance: Float) -> Vector
    {
        if let seekingPosition = groupDelegate?.findSeekingPosition(
            by: self,
            boundingDistance: boundingDistance)
        {
            return position.vector(to: seekingPosition) * weight
        } else {
            return Vector.zero
        }
    }
    
    private func desiredVelocityForCohesion(
        weight: Float,
        boundingDistance: Float) -> Vector
    {
        if let otherAgentPositions = groupDelegate?.findOtherAgentPositionsForCohesion(
            by: self,
            boundingDistance: boundingDistance)
        {
            return position.vectorToCenter(of: otherAgentPositions) * weight
            
        } else {
            return Vector.zero
        }
    }
    
    private func desiredVelocityForSeparation(
        weight: Float,
        boundingDistance: Float) -> Vector
    {
        if let otherAgentPositions = groupDelegate?.findOtherAgentPositionsForSeparation(
            by: self,
            boundingDistance: boundingDistance)
        {
            return position.vectorToCenter(of: otherAgentPositions) * weight * (-1)
            
        } else {
            return Vector.zero
        }
    }
    
    private func desiredVelocityForAlignment(
        weight: Float,
        boundingDistance: Float) -> Vector
    {
        if let otherAgentVelocities = groupDelegate?.findOtherAgentVelocitiesForAlignment(
            by: self,
            boundingDistance: boundingDistance)
        {
            return average(of: otherAgentVelocities) * weight
            
        } else {
            return Vector.zero
        }
    }
}

extension SteeringAgent: Updatable {
    func update(_ currentTime: TimeInterval) {
        
        guard let groupDelegate = groupDelegate else {
            assertionFailure("groupDelegate must be not nil")
            return
        }
        
        guard let behaviorsDataSource = behaviorsDataSource else {
            assertionFailure("behaviorsDataSource must be not nil")
            return
        }
        
        updatingDelegate?.willAgentUpdate(agent: self)
        
        let behaviors = behaviorsDataSource.behaviors(
            of: self,
            isGroupLeader: groupDelegate.isGroupLeader(agent: self),
            hasAchieved: groupDelegate.hasAchieved(agent: self)
        )
        
        velocity = compute(velocity: Vector.zero, behaviors: behaviors)
        position += velocity
        
        groupDelegate.validateToAchieve(agent: self)
                
        updatingDelegate?.didAgentUpdate(agent: self)
    }
}
