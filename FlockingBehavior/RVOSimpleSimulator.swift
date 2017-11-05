//
//  RVOSimulator.swift
//  FlockingBehavior
//
//  Created by Quoc Dung Chu on 30/10/2017.
//  Copyright © 2017 quoc. All rights reserved.
//

import Foundation

class RVOSimpleSimulator {
    
    let timeNoCollision: Double
    var agents = [Agent]()
    var destinations = [Vector]()    
    var computeCount: Int = 0
    
    init(timeNoCollision: Double) {
        self.timeNoCollision = timeNoCollision
    }
}

extension RVOSimpleSimulator: RVOSimulator {
    
    func prepareToCompute() {}
    
    func neighbors(of agent: Agent) -> [Agent] {
        return agents.filter { $0 !== agent }
    }
}
