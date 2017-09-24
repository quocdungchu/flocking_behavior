//
//  Agent.swift
//  FlockingBehavior
//
//  Created by Quoc Dung Chu on 9/24/17.
//  Copyright © 2017 quoc. All rights reserved.
//

import Foundation

protocol AgentDelegate {
    func seekingPosition(for agent: Agent) -> Vect2?
}

class Agent {
    var position: Vect2
    let behaviors: [Behavior]
    let maximumSpeed: Float
    let minimumSpeed: Float
    
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
        position: Vect2,
        rotation: Vect2,
        speed: Float,
        behaviors: [Behavior],
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
        let newVelocity = compute(velocity: velocity, withBehaviors: behaviors)
        if newVelocity.length >= minimumSpeed {
            velocity = newVelocity
            position += velocity
            
        } else {
            speed = 0
        }
    }
    
    private func compute(velocity: Vect2, withOther other: Vect2) -> Vect2 {
        let newVelocity = velocity + other
        return clamp(velocity: newVelocity)
    }
    
    
    private func compute(velocity: Vect2, withBehaviors behaviors: [Behavior]) -> Vect2 {
        return behaviors.reduce(velocity) {
            compute(velocity: $0, withBehavior: $1)
        }
    }
    
    private func compute(velocity: Vect2, withBehavior behavior: Behavior) -> Vect2 {
        switch behavior {
        case .seeking (let weight, let visibleDistance):
            return compute(velocity: velocity, withOther: calculateSeeking(
                weight: weight,
                visibleDistance: visibleDistance
            ))
            
        default:
            return velocity
        }
    }
    
    private func calculateSeeking(
        weight: Float,
        visibleDistance: Float) -> Vect2
    {
        if let seekingPosition = delegate?.seekingPosition(for: self),
            visibleDistance > position.distance(to: seekingPosition)
        {
            return vectorTo(point: seekingPosition) * weight
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
