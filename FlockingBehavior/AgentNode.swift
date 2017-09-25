//
//  AgentNode.swift
//  FlockingBehavior
//
//  Created by Quoc Dung Chu on 9/24/17.
//  Copyright © 2017 quoc. All rights reserved.
//

import SpriteKit


class AgentNode: SKShapeNode {
    
    let size: CGFloat = 30
    
    var agent: Agent
    
    init(position: Vect2) {
        self.agent = Agent(
            behaviors: [
                .seeking(weight: 0.004, visibleDistance: 10000),
                .seeking(weight: 0.01, visibleDistance: 300),
                .cohesion(weight: 0.001, visibleDistance: 100),
                .separation(weight: 0.015, visibleDistance: 66),
                .separation(weight: 0.2, visibleDistance: 30),
                .alignment(weight: 0.008, visibleDistance: 150)
            ],
            position: position,
            rotation: Vect2(0, 1),
            speed: 0,
            maximumSpeed: 1.5,
            minimumSpeed: 2
        )
        super.init()
        
        self.position = CGPoint(agent.position)
        self.zRotation = CGFloat(agent.rotation.angle - Float.pi / 2)
        
        draw()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func draw(){
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: size * 0.5))
        path.addLine(to: CGPoint(x: size * 0.5, y: -size * 0.5))
        path.addLine(to: CGPoint(x: -size * 0.5, y: -size * 0.5))
        path.close()
        
        self.path = path.cgPath
        self.strokeColor = UIColor.red
        self.lineWidth = 2
    }
    
    func update(elapsedTime: TimeInterval, frameCount: Int){
        agent.position = Vect2(position)
        agent.update()
     
        self.position = CGPoint(agent.position)
      
        if frameCount % 15 == 0 {
            self.zRotation = CGFloat(agent.rotation.angle - Float.pi / 2)
        }
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

