//
//  Agent.swift
//  FlockingBehavior
//
//  Created by Quoc Dung Chu on 21/10/2017.
//  Copyright © 2017 quoc. All rights reserved.
//

import Foundation

class Agent {
    let position: Vector
    let radius: Float
    let velocity: Vector
    let preferredVelocity: Vector
    
    init(
        position: Vector,
        radius: Float,
        velocity: Vector = Vector.zero,
        preferredVelocity: Vector = Vector.zero)
    {
        self.position = position
        self.radius = radius
        self.velocity = velocity
        self.preferredVelocity = preferredVelocity
    }
}

extension Agent {
    func orcaLine(
        neighbor: Agent,
        noCollisionDeltaTime: Double,
        timeStep: Double) -> Line?
    {
        guard noCollisionDeltaTime != 0.0 && timeStep != 0.0 else {
            return nil
        }
        
        let relativePosition = neighbor.position - position
        let relativeVelocity = velocity - neighbor.velocity
        let squaredDistance = relativePosition.squaredLength
        let combinedRadius = radius + neighbor.radius
        let squaredCombinedRadius = sqr(combinedRadius)
        
        let direction: Vector
        let u: Vector
        
        if squaredDistance > combinedRadius {
            let invNoCollisionDeltaTime = Float(1.0 / noCollisionDeltaTime)

            let cutoffCenter = invNoCollisionDeltaTime * relativePosition
            let w = relativeVelocity - cutoffCenter
            let wSquaredLength = w.squaredLength
            
            let dotProduct = w * relativePosition
            let isProjectInCutOffCircle = dotProduct < 0.0
                && sqr(dotProduct) > combinedRadius * wSquaredLength
            
            if isProjectInCutOffCircle {
                let wLenght = w.length
                let wUnit = w / wLenght
                
                direction = Vector(wUnit.y, -wUnit.x)
                u = (combinedRadius * invNoCollisionDeltaTime - wLenght) * wUnit
                
            } else {
                let leg = sqrtf(squaredDistance - squaredCombinedRadius)
                let isProjectOnLeftLeg = determinant(of: relativeVelocity, and: w) > 0.0
                
                if isProjectOnLeftLeg {
                    direction = Vector(
                        relativeVelocity.x * leg - relativeVelocity.y * combinedRadius,
                        relativePosition.x * combinedRadius + relativeVelocity.y * leg
                    ) / squaredDistance
                    
                } else {
                    direction = Vector(
                        relativeVelocity.x * leg + relativeVelocity.y * combinedRadius,
                        -relativePosition.x * combinedRadius + relativeVelocity.y * leg
                    ) / squaredDistance
                }
                
                let dotProduct2 = relativeVelocity * direction
                u = dotProduct2 * direction - relativeVelocity
            }
        } else {
            let invTimeStep = Float(1.0 / timeStep)
            
            let w = relativeVelocity - invTimeStep * relativePosition
            let wLength = w.length
            let wUnit = w / wLength
            
            direction = Vector(wUnit.y, -wUnit.x)
            u = (combinedRadius * invTimeStep - wLength) * wUnit
        }
        
        return Line(point: velocity + 0.5 * u, direction: direction)
    }
}
