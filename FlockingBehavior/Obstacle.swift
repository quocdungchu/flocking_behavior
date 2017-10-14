//
//  Obstacle.swift
//  FlockingBehavior
//
//  Created by Quoc Dung Chu on 14/10/2017.
//  Copyright © 2017 quoc. All rights reserved.
//

class Obstacle {
    private (set) var point = Vector.zero
    private (set) var next: Obstacle?
    private (set) var previous: Obstacle?
    private (set) var convexe: Bool = false
    private (set) var pointCount: Int = 0
    
    static func buildObstacle(vertices: [Vector]) -> Obstacle? {
        guard vertices.count >= 2 else {
            return nil
        }
        
        var first: Obstacle?
        var previous: Obstacle?
        var current: Obstacle?
        
        for i in 0..<vertices.count {
            let currentPoint = vertices[i]
            
            current = Obstacle()
            current?.point = currentPoint
            current?.pointCount = vertices.count
            
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
    
    func enumerate(body: (Obstacle) -> Void){
        var current: Obstacle = self
        for _ in 0...(pointCount - 1) {
            body(current)
            current = current.next!
        }
    }
}
