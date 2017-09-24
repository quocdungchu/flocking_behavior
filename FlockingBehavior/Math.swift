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
}

func sum(of vectors: [Vect2]) -> Vect2 {
    return vectors.reduce(Vect2.zero) { $0 + $1 }
}

func average(of vectors: [Vect2]) -> Vect2 {
    return vectors.isEmpty ?
        Vect2.zero:
        sum(of: vectors) / Float(vectors.count)
}
