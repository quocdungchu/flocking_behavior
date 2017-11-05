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
    let color: UIColor
    
    init(agent: Agent, scale: Float, color: UIColor) {
        self.agent = agent
        self.scale = scale
        self.color = color
        
        super.init()
        
        drawPath()
        update()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func drawPath(){
        let path = UIBezierPath()
        path.move(to: CGPoint(0, agent.radius * scale))
        path.addLine(to: CGPoint(agent.radius * scale, -agent.radius * scale))
        path.addLine(to: CGPoint(0, 0))
        path.addLine(to: CGPoint(-agent.radius * scale, -agent.radius * scale))
        path.close()
        
        let bounding = UIBezierPath()
        bounding.addArc(
            withCenter: CGPoint(0, 0),
            radius: CGFloat(agent.radius * scale),
            startAngle: 0,
            endAngle: CGFloat(2 * Float.pi),
            clockwise: true
        )
        
        path.append(bounding)
        
        self.path = path.cgPath
        self.strokeColor = color
        self.lineWidth = 1
    }
    
    func update(){
        self.position = CGPoint(vector: agent.position * scale)
        self.zRotation = CGFloat(agent.rotation.angle - Float.pi / 2)
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

