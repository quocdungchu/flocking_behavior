//
//  Obstacle.swift
//  FlockingBehavior
//
//  Created by Quoc Dung Chu on 14/10/2017.
//  Copyright © 2017 quoc. All rights reserved.
//

class Obstacle {
    let point: Vector
    private (set) var next: Obstacle?
    private (set) var previous: Obstacle?
    private (set) var convexe: Bool = false
    
    static func buildObstacle(vertices: [Vector]) -> Obstacle? {
        guard vertices.count >= 2 else {
            return nil
        }
        
        var first: Obstacle?
        var previous: Obstacle?
        var current: Obstacle?
        
        for i in 0..<vertices.count {
            let currentPoint = vertices[i]
            current = Obstacle(point: currentPoint)
            
            current?.previous = previous
            previous?.next = current
            
            if i == 0 {
                first = current
            }
            
            if i == (vertices.count - 1) {
                current?.next = first
                first?.previous = current
            }
            
            let nextPoint = vertices[i == (vertices.count - 1) ? 0: (i+1)]
            let previousPoint = vertices[i == 0 ? (vertices.count - 1): (i-1)]
            
            current?.convexe = leftOf(start: previousPoint, end: nextPoint, point: currentPoint) >= 0
            
            previous = current
        }
        return first
    }
    
    private init(point: Vector){
        self.point = point
    }
}
