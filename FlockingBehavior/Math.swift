//
//  Math.swift
//  FlockingBehavior
//
//  Created by Quoc Dung Chu on 14/10/2017.
//  Copyright © 2017 quoc. All rights reserved.
//

func sum(of vectors: [Vector]) -> Vector {
    return vectors.reduce(Vector.zero) { $0 + $1 }
}

func average(of vectors: [Vector]) -> Vector {
    return vectors.isEmpty ?
        Vector.zero:
        sum(of: vectors) / Float(vectors.count)
}

func determinant(of vector1: Vector, and vector2: Vector) -> Float {
    return vector1.x * vector2.y - vector1.y * vector2.x
}

func leftOf(start: Vector, end: Vector, point: Vector) -> Float {
    return determinant(of: start - point, and: end - start)
}

func intersection(start1: Vector, end1: Vector, start2: Vector, end2: Vector) -> Vector? {
    let det2 = determinant(of: (end1 - start1), and: (start2 - end2))
    
    guard det2 != 0 else {
        return nil
    }
    
    let det1 = determinant(of: (end1 - start1), and: (start2 - start1))
    
    return start2 + (end2 - start2) * (det1/det2)
}

func squaredDistance(point: Vector, segmentStart start: Vector, segmentEnd end: Vector) -> Float {
    let r = ((point - start) * (end - start)) / (end - start).squaredLength
    
    if r < 0.0 {
        return (point - start).squaredLength
        
    } else if r > 1.0 {
        return (point - end).squaredLength
        
    } else {
        return (point - (start + (end - start) * r)).squaredLength
    }
}

func squaredDistance(point: Vector, lineStart start: Vector, lineEnd end: Vector) -> Float {
    let r = ((point - start) * (end - start)) / (end - start).squaredLength
    return (point - (start + (end - start) * r)).squaredLength
}

func shortestAngleBetween(_ angle1: Float, angle2: Float) -> Float {
    let pi = Float.pi
    let twoPi = pi * 2.0
    var angle = (angle2 - angle1).truncatingRemainder(dividingBy: twoPi)
    if (angle >= pi) {
        angle = angle - twoPi
    }
    if (angle <= -pi) {
        angle = angle + twoPi
    }
    return angle
}

func sqr(_ value: Float) -> Float {
    return value * value
}
