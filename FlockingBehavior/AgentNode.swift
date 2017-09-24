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
            behaviors: [
                .seeking(weight: 0.5, visibleDistance: 1000)
            ],
            position: Vect2.zero,
            rotation: Vect2(0, 1),
            speed: 0,
            maximumSpeed: 2.5,
            minimumSpeed: 2
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
    
    func update(elapsedTime: TimeInterval, frameCount: Int){
        agent.position = Vect2(position)
        agent.update()
        position = CGPoint(agent.position)
        zRotation = CGFloat(agent.rotation.angle - Float.pi / 2)
    }
    
    private func updateRenderer(elapsedTime: TimeInterval, frameCount: Int){
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

