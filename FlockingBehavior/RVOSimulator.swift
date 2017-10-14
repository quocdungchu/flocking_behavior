//
//  RVOSimulator.swift
//  FlockingBehavior
//
//  Created by Quoc Dung Chu on 14/10/2017.
//  Copyright © 2017 quoc. All rights reserved.
//

class RVOSimulator {
    var obstacles = [Obstacle]()
    
    func addObstacle(with vertices: [Vector]) {
        let obstacle = Obstacle.buildObstacle(vertices: vertices)
        obstacle?.enumerate {
            obstacles.append($0)
        }
    }
}
