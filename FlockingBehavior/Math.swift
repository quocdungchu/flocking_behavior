//
//  Math.swift
//  FlockingBehavior
//
//  Created by Quoc Dung Chu on 9/24/17.
//  Copyright © 2017 quoc. All rights reserved.
//

import Foundation

struct Vect2 {
    let x: Float
    let y: Float
    
    static var zero: Vect2 {
        return Vect2(0,0)
    }
    
    var length: Float {
        return sqrtf(x * x + y * y)
    }
    
    var normalized: Vect2 {
        return length == 0 ? Vect2.zero: self / length
    }
    
    var angle: Float {
        return atan2(y, x)
    }
    
    init(_ x: Float, _ y: Float){
        self.x = x
        self.y = y
    }
    
    static func + (left: Vect2, right: Vect2) -> Vect2 {
        return Vect2(left.x + right.x, left.y + right.y)
    }
    
    static func += (left: inout Vect2, right: Vect2) {
        left = left + right
    }
    
    static func - (left: Vect2, right: Vect2) -> Vect2 {
        return Vect2(left.x - right.x, left.y - right.y)
    }
    
    static func -= (left: inout Vect2, right: Vect2) {
        left = left - right
    }
    
    static func * (vector: Vect2, value: Float) -> Vect2 {
        return Vect2(vector.x * value, vector.y * value)
    }
    
    static func *= (left: inout Vect2, value: Float) {
        left = left * value
    }
    
    static func / (vector: Vect2, value: Float) -> Vect2 {
        return Vect2(vector.x / value, vector.y / value)
    }
    
    static func /= (left: inout Vect2, value: Float) {
        left = left / value
    }
    
    func distance(to vector: Vect2) -> Float {
        let dx = x - vector.x
        let dy = y - vector.y
        return sqrtf(dx * dx + dy * dy)
    }
    
    func limit(in maximumLength: Float) -> Vect2 {
        if length > maximumLength {
            return normalized * maximumLength
            
        } else {
            return self
        }
    }
}

func sum(of vectors: [Vect2]) -> Vect2 {
    return vectors.reduce(Vect2.zero) { $0 + $1 }
}

func average(of vectors: [Vect2]) -> Vect2 {
    return vectors.isEmpty ?
        Vect2.zero:
        sum(of: vectors) / Float(vectors.count)
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

