//
//  Agent.swift
//  FlockingBehavior
//
//  Created by Quoc Dung Chu on 9/24/17.
//  Copyright © 2017 quoc. All rights reserved.
//

import Foundation

class Agent {
    var position: Vect2
    var velocity: Vect2
    let behaviors: [Behavior]
    
    init(position: Vect2, velocity: Vect2, behaviors: [Behavior]) {
        self.position = position
        self.velocity = velocity
        self.behaviors = behaviors
    }
    
    func update(){
        position += velocity
    }
    
    private func clampVelocity() {
    
    }
}
