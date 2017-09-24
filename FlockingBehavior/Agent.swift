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
    var velocity: Vect2
    let behaviors: [Behavior]
    let maximumSpeed: Float
    let minimumDistanceToMove: Float
    
    var delegate: AgentDelegate?
    
    init(
        position: Vect2,
        velocity: Vect2,
        behaviors: [Behavior],
        maximumSpeed: Float,
        minimumDistanceToMove: Float)
    {
        self.position = position
        self.velocity = velocity
        self.behaviors = behaviors
        self.maximumSpeed = maximumSpeed
        self.minimumDistanceToMove = minimumDistanceToMove
    }
    
    func update(){
        behaviors.forEach { compute(for: $0) }
        
        if velocity.length >= minimumDistanceToMove {
            position += velocity
            
        } else {
            velocity = Vect2.zero
        }
    }
    
    private func computeVelocity(with newVelocity: Vect2) {
        print("current speed \(velocity.length)")
        velocity += newVelocity
        print("new speed \(velocity.length)")

        clampVelocity()
        print("after clamp speed \(velocity.length)")

    }
    
    private func compute(for behavior: Behavior) {
        switch behavior {
        case .seeking (let weight, let visibleDistance, let achievedDistance):
            computeVelocity(with: calculateSeeking(
                weight: weight,
                visibleDistance: visibleDistance,
                achievedDistance: achievedDistance
            ))
            
        default:
            break
        }
    }
    
    private func calculateSeeking(
        weight: Float,
        visibleDistance: Float,
        achievedDistance: Float) -> Vect2
    {
        if let seekingPosition = delegate?.seekingPosition(for: self),
            visibleDistance > position.distance(to: seekingPosition),
            achievedDistance < position.distance(to: seekingPosition)
        {
            print("distance \(position.distance(to: seekingPosition))")
            return vectorTo(point: seekingPosition) * weight
        } else {
            return Vect2.zero
        }
    }
    
    private func clampVelocity() {
        let speed = velocity.length
        if speed > maximumSpeed {
            velocity = velocity.normalized * maximumSpeed
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
