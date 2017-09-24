//
//  Behavior.swift
//  FlockingBehavior
//
//  Created by Quoc Dung Chu on 9/24/17.
//  Copyright © 2017 quoc. All rights reserved.
//

enum Behavior {
    case cohesion
    case separation
    case alignment
    case seeking (weight: Float, visibleDistance: Float)
}
