//
//  Agent.swift
//  FlockingBehavior
//
//  Created by Quoc Dung Chu on 21/10/2017.
//  Copyright © 2017 quoc. All rights reserved.
//

import Foundation

class Agent {
    var position: Vector
    let radius: Float
    let maxSpeed: Float
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
    
    init(
        position: Vector,
        radius: Float,
        maxSpeed: Float,
        velocity: Vector = Vector.zero)
    {
        self.position = position
        self.radius = radius
        self.maxSpeed = maxSpeed
        self.rotation = velocity.normalized
        self.speed = velocity.length
    }
    
    func update(
        preferredVelocity: Vector,
        neighbors: [Agent],
        noCollisionDeltaTime: Double,
        timeStep: Double)
    {
        velocity = computedVelocity(
            preferredVelocity: preferredVelocity,
            neighbors: neighbors,
            noCollisionDeltaTime: noCollisionDeltaTime,
            timeStep: timeStep
        )
        position += velocity * Float(timeStep)
    }
    
    func computedVelocity(
        preferredVelocity: Vector,
        neighbors: [Agent],
        noCollisionDeltaTime: Double,
        timeStep: Double) -> Vector
    {
        let ocraLines = neighbors.flatMap {
            self.orcaLine(
                preferredVelocity: preferredVelocity,
                neighbor: $0,
                noCollisionDeltaTime: noCollisionDeltaTime,
                timeStep: timeStep
            )
        }
        
        let linearProgram2Result = LineComputer.linearProgram2(
            lines: ocraLines,
            radius: maxSpeed,
            optimalVelocity: preferredVelocity,
            directionOptimal: true
        )
        
        if let failIndex = linearProgram2Result.failIndex {
            return LineComputer.linearProgram3(
                lines: ocraLines,
                numberOfObstacleLines: 0,
                beginLineIndex: failIndex,
                radius: maxSpeed,
                computedVelocity: Vector.zero
            )
        } else {
            return linearProgram2Result.computedVelocity
        }
    }
    
    func orcaLine(
        preferredVelocity: Vector,
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
        
        if squaredDistance > squaredCombinedRadius {
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

enum LineComputer {
    
    struct LinearProgram2Result {
        let computedVelocity: Vector
        let failIndex: Int?
    }
    
    static func linearProgram1(
        lines: [Line],
        lineIndex: Int,
        radius: Float,
        optimalVelocity: Vector,
        directionOptimal: Bool) -> Vector?
    {
        guard lineIndex >= 0 && lineIndex < lines.count else {
            return nil
        }
        
        let dotProduct = lines[lineIndex].point * lines[lineIndex].direction
        let discriminant = sqr(dotProduct) + sqr(radius) - lines[lineIndex].point.squaredLength
        
        guard discriminant >= 0.0 else {
            return nil
        }
        
        let sqrtDiscriminant = sqrtf(discriminant)
        
        var tLeft = -dotProduct - sqrtDiscriminant
        var tRight = -dotProduct + sqrtDiscriminant
        
        for i in 0..<lineIndex {
            let denominator = determinant(of: lines[lineIndex].direction, and: lines[i].direction)
            let numerator = determinant(of: lines[i].direction, and: lines[lineIndex].point - lines[i].point)
            
            if fabsf(denominator) <= RVOConstants.epsilon {
                if numerator < 0.0 {
                    return nil
                } else {
                    continue
                }
            }
            
            let t = numerator / denominator
            
            if denominator >= 0.0 {
                tRight = min(tRight, t)
            } else {
                tLeft = max(tLeft, t)
            }
            
            if tLeft > tRight {
                return nil
            }
        }
        
        if directionOptimal {
            if optimalVelocity * lines[lineIndex].direction > 0.0 {
                return lines[lineIndex].point + tRight * lines[lineIndex].direction
                
            } else {
                return lines[lineIndex].point + tLeft * lines[lineIndex].direction
            }
        } else {
            let t = lines[lineIndex].direction * (optimalVelocity - lines[lineIndex].point)
            
            if t < tLeft {
                return lines[lineIndex].point + tLeft * lines[lineIndex].direction
                
            } else if t > tRight {
                return lines[lineIndex].point + tRight * lines[lineIndex].direction
                
            } else {
                return lines[lineIndex].point + t * lines[lineIndex].direction
            }
        }
    }
    
    static func linearProgram2(
        lines: [Line],
        radius: Float,
        optimalVelocity: Vector,
        directionOptimal: Bool) -> LinearProgram2Result
    {
        var newVelocity: Vector
        if directionOptimal {
            newVelocity = optimalVelocity * radius
            
        } else if optimalVelocity.squaredLength > sqr(radius) {
            newVelocity = optimalVelocity.normalized * radius
        
        } else {
            newVelocity = optimalVelocity
        }
        
        for i in 0..<lines.count {
            if determinant(of: lines[i].direction, and: lines[i].point - newVelocity) > 0.0 {
                guard let computed = linearProgram1(
                    lines: lines,
                    lineIndex: i,
                    radius: radius,
                    optimalVelocity: optimalVelocity,
                    directionOptimal: directionOptimal) else
                {
                    return LinearProgram2Result(computedVelocity: newVelocity, failIndex: i)
                }
                newVelocity = computed
            }
        }
        
        return LinearProgram2Result(computedVelocity: newVelocity, failIndex: nil)
    }
    
    static func linearProgram3(
        lines: [Line],
        numberOfObstacleLines: Int,
        beginLineIndex: Int,
        radius: Float,
        computedVelocity: Vector) -> Vector
    {
        var distance: Float = 0.0
        
        var result = computedVelocity
        
        for i in beginLineIndex..<lines.count {
            if determinant(of: lines[i].direction, and: lines[i].point - result) > distance {
                var projectLines = [Line]()
                
                for j in numberOfObstacleLines..<i {
                    let point: Vector
                    let direction: Vector
                    
                    let det = determinant(of: lines[i].direction, and: lines[j].direction)
                    
                    if fabs(det) <= RVOConstants.epsilon {
                        if lines[i].direction * lines[j].direction > 0.0 {
                            continue
                        
                        } else {
                            point = 0.5 * lines[i].point + lines[j].point
                        }
                    } else {
                        point = lines[i].point + (determinant(of: lines[j].direction, and: lines[i].point - lines[j].point) / det) * lines[i].direction
                    }
                    
                    direction = (lines[j].direction - lines[i].direction).normalized
                    projectLines.append(Line(point: point, direction: direction))
                }
                
                let linearProgram2Result = linearProgram2(lines: lines, radius: radius, optimalVelocity: Vector(-lines[i].direction.y, lines[i].direction.x), directionOptimal: true)
                
                if linearProgram2Result.failIndex != nil {
                    result = linearProgram2Result.computedVelocity
                }
                
                distance = determinant(of: lines[i].direction, and: lines[i].point - result)
            }
        }
        
        return result
    }
}
