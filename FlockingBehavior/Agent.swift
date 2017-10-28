//
//  Agent.swift
//  FlockingBehavior
//
//  Created by Quoc Dung Chu on 21/10/2017.
//  Copyright © 2017 quoc. All rights reserved.
//

class Agent {
    let position: Vector
    let radius: Float
    let vector: Vector
    let preferredVector: Vector
    
    init(
        position: Vector,
        radius: Float,
        vector: Vector = Vector.zero,
        preferredVector: Vector = Vector.zero)
    {
        self.position = position
        self.radius = radius
        self.vector = vector
        self.preferredVector = preferredVector
    }
}
