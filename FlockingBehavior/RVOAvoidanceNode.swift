//
//  RVOAvoidanceNode.swift
//  FlockingBehavior
//
//  Created by Quoc Dung Chu on 29/10/2017.
//  Copyright © 2017 quoc. All rights reserved.
//

import SpriteKit

class RVOAvoidanceNode: SKShapeNode {
    let agent: Agent
    let neighbors: [Agent]
    let scale: Float
    let timeNoCollision: Double
    let timeStep: Double
    let destinationPoint: Vector
    
    let relativePositionNodes: [SKShapeNode]
    let relativeVelocityNodes: [SKShapeNode]
    let ocraLineNodes: [SKShapeNode]
    
    init(agent: Agent, neighbors: [Agent], scale: Float = RVOExampleConstants.scale, timeNoCollision: Double, timeStep: Double, destinationPoint: Vector) {
        self.agent = agent
        self.neighbors = neighbors
        self.scale = scale
        self.timeNoCollision = timeNoCollision
        self.timeStep = timeStep
        self.destinationPoint = destinationPoint

        self.relativePositionNodes = neighbors.map { _ in
            let node = SKShapeNode()
            node.strokeColor = UIColor.cyan
            node.lineWidth = 1
            return node
        }
        
        self.relativeVelocityNodes = neighbors.map { _ in
            let node = SKShapeNode()
            node.strokeColor = UIColor.blue
            node.lineWidth = 1
            return node
        }
        
        self.ocraLineNodes = neighbors.map { _ in
            let node = SKShapeNode()
            node.strokeColor = UIColor.red
            node.lineWidth = 1
            return node
        }
        
        super.init()
        
        addNodes()
        update()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func ocraLinePath(agent: Agent, neighbor: Agent) -> UIBezierPath {
        
        let line = agent.orcaLine(preferredVelocity: destinationPoint - agent.position, neighbor: neighbor, timeNoCollision: timeNoCollision, timeStep: timeStep)
        
        let path = UIBezierPath()
        
        if let line = line {
            path.move(to: CGPoint(vector: line.point * scale))
            path.addLine(to: CGPoint((line.point + line.direction) * scale * 1))
            path.move(to: CGPoint(vector: line.point * scale))
            path.addLine(to: CGPoint((line.point - line.direction) * scale))
        }
        
        return path
    }
    
    private func relativePositionPath(agent: Agent, neighbor: Agent) -> UIBezierPath {
        let center = CGPoint(vector: (neighbor.position - agent.position) * scale)
        let radius = CGFloat((agent.radius + neighbor.radius) * scale)
        
        let smallCenter = CGPoint(vector: (neighbor.position - agent.position) * Float(1.0 / timeNoCollision) * scale)
        let smallRadius = CGFloat((agent.radius + neighbor.radius) * Float(1.0 / timeNoCollision) * scale)

        let path = UIBezierPath()
        path.move(to: CGPoint(vector: Vector.zero))
        path.addLine(to: center)
        
        path.move(to: center)
        path.addArc(withCenter: center, radius: radius, startAngle: 0, endAngle: CGFloat(2 * Float.pi), clockwise: true)
        
        path.move(to: smallCenter)
        path.addArc(withCenter: smallCenter, radius: smallRadius, startAngle: 0, endAngle: CGFloat(2 * Float.pi), clockwise: true)
                
        return path
    }
    
    private func relativeVelocityPath(agent: Agent, neighbor: Agent) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(vector: Vector.zero))
        path.addLine(to: CGPoint(vector: (agent.velocity - neighbor.velocity) * scale))
        
        return path
    }
    
    private func addNodes(){
        relativePositionNodes.forEach {
            addChild($0)
        }
        
        relativeVelocityNodes.forEach {
            addChild($0)
        }
        
        ocraLineNodes.forEach {
            addChild($0)
        }
    }
    
    func update(){
        self.position = CGPoint(vector: agent.position * scale)
        draw()
    }
    
    func draw(){
        for i in 0..<neighbors.count {
            relativePositionNodes[i].path = relativePositionPath(agent: agent, neighbor: neighbors[i]).cgPath
            relativeVelocityNodes[i].path = relativeVelocityPath(agent: agent, neighbor: neighbors[i]).cgPath
            ocraLineNodes[i].path = ocraLinePath(agent: agent, neighbor: neighbors[i]).cgPath
        }
    }
}
