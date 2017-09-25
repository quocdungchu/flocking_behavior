//
//  Behavior.swift
//  FlockingBehavior
//
//  Created by Quoc Dung Chu on 9/24/17.
//  Copyright © 2017 quoc. All rights reserved.
//

enum Behavior {
    case cohesion (weight: Float, visibleDistance: Float)
    case separation (weight: Float, visibleDistance: Float)
    case alignment (weight: Float, visibleDistance: Float)
    case seeking (weight: Float, visibleDistance: Float)
}
