//
//  AgentNode.swift
//  FlockingBehavior
//
//  Created by Quoc Dung Chu on 9/24/17.
//  Copyright © 2017 quoc. All rights reserved.
//

import SpriteKit


class AgentNode: SKShapeNode {
    
    var agent: Agent
    
    override init() {
        self.agent = Agent(
            position: Vect2.zero,
            velocity: Vect2.zero,
            behaviors: [
                .seeking(weight: 10, visibleDistance: 1000, achievedDistance: 0)
            ],
            maximumSpeed: 1.5,
            minimumDistanceToMove: 1
        )
        super.init()
        
        draw()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func draw(){
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 50))
        path.addLine(to: CGPoint(x: 30, y: -30))
        path.addLine(to: CGPoint(x: -30, y: -30))
        path.close()
        
        self.path = path.cgPath
        self.strokeColor = UIColor.red
        self.lineWidth = 2
    }
    
    func update(elapsedTime: TimeInterval){
        agent.position = Vect2(position)
        
        agent.update()
        
        position = CGPoint(agent.position)
    }
    
    func move(to: CGPoint) {
        
    }
}

extension Vect2 {
    init(_ point: CGPoint) {
        self.init(Float(point.x), Float(point.y))
    }
}

extension CGPoint {
    init(_ vector: Vect2) {
        self.init(x: CGFloat(vector.x), y: CGFloat(vector.y))
    }
}
