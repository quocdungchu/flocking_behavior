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
