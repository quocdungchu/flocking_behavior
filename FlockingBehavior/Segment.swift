//
//  Segment.swift
//  FlockingBehavior
//
//  Created by Quoc Dung Chu on 14/10/2017.
//  Copyright © 2017 quoc. All rights reserved.
//

struct Segment {
    let start: Vector
    let end: Vector

    var direction: Vector {
       return (end - start).normalized
    }
}
