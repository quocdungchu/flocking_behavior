//
//  Math.swift
//  FlockingBehavior
//
//  Created by Quoc Dung Chu on 9/24/17.
//  Copyright © 2017 quoc. All rights reserved.
//

import Foundation

struct Vector {
    let x: Float
    let y: Float
    
    static var zero: Vector {
        return Vector(0,0)
    }
    
    var length: Float {
        return sqrtf(squaredLength)
    }
    
    var squaredLength: Float {
        return self * self
    }
    
    var normalized: Vector {
        return length == 0 ? Vector.zero: self / length
    }
    
    var angle: Float {
        return atan2(y, x)
    }
    
    init(_ x: Float, _ y: Float){
        self.x = x
        self.y = y
    }
    
    static func + (left: Vector, right: Vector) -> Vector {
        return Vector(left.x + right.x, left.y + right.y)
    }
    
    static func += (left: inout Vector, right: Vector) {
        left = left + right
    }
    
    static func - (left: Vector, right: Vector) -> Vector {
        return Vector(left.x - right.x, left.y - right.y)
    }
    
    static func -= (left: inout Vector, right: Vector) {
        left = left - right
    }
    
    static func * (vector: Vector, value: Float) -> Vector {
        return Vector(vector.x * value, vector.y * value)
    }
    
    static func * (value: Float, vector: Vector) -> Vector {
        return vector * value
    }
    
    static func *= (left: inout Vector, value: Float) {
        left = left * value
    }
    
    static func / (vector: Vector, value: Float) -> Vector {
        return Vector(vector.x / value, vector.y / value)
    }
    
    static func /= (left: inout Vector, value: Float) {
        left = left / value
    }
    
    static func * (vector1: Vector, vector2: Vector) -> Float {
        return vector1.x * vector2.x + vector1.y * vector2.y
    }
    
    func distance(to vector: Vector) -> Float {
        let dx = x - vector.x
        let dy = y - vector.y
        return sqrtf(dx * dx + dy * dy)
    }
    
    func vector(to other: Vector) -> Vector {
        return other - self
    }
    
    func vectorToCenter(of points: [Vector]) -> Vector {
        return points.isEmpty ?
            Vector.zero:
            vector(to: average(of: points))
    }
    
    func limitedVector(maximumLength: Float) -> Vector {
        if length > maximumLength {
            return normalized * maximumLength
            
        } else {
            return self
        }
    }
}

extension Vector: Equatable {
    static func == (lhs: Vector, rhs: Vector) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
}

