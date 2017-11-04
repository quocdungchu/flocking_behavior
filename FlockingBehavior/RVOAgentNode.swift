//
//  RVOAgentNode.swift
//  FlockingBehavior
//
//  Created by Quoc Dung Chu on 29/10/2017.
//  Copyright © 2017 quoc. All rights reserved.
//

import SpriteKit

enum RVOExampleConstants {
    static let scale: Float = 10.0
}

class RVOAgentNode: SKShapeNode {
    let agent: Agent
    let scale: Float
    
    init(agent: Agent, scale: Float = RVOExampleConstants.scale) {
        self.agent = agent
        self.scale = scale
        
        super.init()
        
        addNodes()
        update()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addNodes(){
        
        addChild(boundingNode())
        addChild(drawingNode())
    }
    
    func update(){
        self.position = CGPoint(vector: agent.position * scale)
        self.zRotation = CGFloat(agent.rotation.angle - Float.pi / 2)
    }
    
    private func boundingNode() -> SKShapeNode {
        let boundingNode = SKShapeNode()
        let bounding = UIBezierPath()
        bounding.addArc(withCenter: CGPoint(0, 0), radius: CGFloat(agent.radius * scale), startAngle: 0, endAngle: CGFloat(2 * Float.pi), clockwise: true)
        boundingNode.path = bounding.cgPath
        boundingNode.strokeColor = UIColor.green
        boundingNode.lineWidth = 1
        return boundingNode
    }
    
    private func drawingNode() -> SKShapeNode {
        let drawingNode = SKShapeNode()
        let path = UIBezierPath()
        path.move(to: CGPoint(0, agent.radius * scale))
        path.addLine(to: CGPoint(agent.radius * scale, -agent.radius * scale))
        path.addLine(to: CGPoint(0, 0))
        path.addLine(to: CGPoint(-agent.radius * scale, -agent.radius * scale))
        path.close()
        
        drawingNode.path = path.cgPath
        drawingNode.strokeColor = UIColor.green
        drawingNode.lineWidth = 2
        
        return drawingNode
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

