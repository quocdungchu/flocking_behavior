//
//  Behavior.swift
//  FlockingBehavior
//
//  Created by Quoc Dung Chu on 9/24/17.
//  Copyright © 2017 quoc. All rights reserved.
//

struct Behavior {
    enum `Type` {
        case cohesion, separation, alignment
    }
    
    let type: Type
    let visibleDistance: Float
    let weight: Float
}
