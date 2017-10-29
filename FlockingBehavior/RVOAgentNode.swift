//
//  RVOAgentNode.swift
//  FlockingBehavior
//
//  Created by Quoc Dung Chu on 29/10/2017.
//  Copyright © 2017 quoc. All rights reserved.
//

import SpriteKit

class RVOAgentNode: SKShapeNode {
    let agent: Agent
    let scale: Float
    
    init(agent: Agent, scale: Float = 20.0) {
        self.agent = agent
        self.scale = scale
        
        super.init()
        
        self.position = CGPoint(vector: agent.position * scale)
        
        draw()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func draw(){
        let path = UIBezierPath()
        path.move(to: CGPoint(0, agent.radius * scale))
        path.addLine(to: CGPoint(agent.radius * scale, -agent.radius * scale))
        path.addLine(to: CGPoint(-agent.radius * scale, -agent.radius * scale))
        path.close()
        
        self.path = path.cgPath
        self.strokeColor = UIColor.red
        self.lineWidth = 2
    }
    
    func update(){
        self.position = CGPoint(vector: agent.position * scale)
    }
}

extension CGPoint {
    init(_ x: Float, _ y: Float) {
        self.init(x: CGFloat(x), y: CGFloat(y))
    }
    
    init(vector: Vector) {
        self.init(vector.x, vector.y)
    }
}

