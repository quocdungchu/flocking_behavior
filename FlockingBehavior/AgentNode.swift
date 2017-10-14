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
    
    var agent: SteeringAgent
    
    var frameCount: Int = 0
    
    init(position: Vector) {
        self.agent = SteeringAgent(
            id: UUID().hashValue,
            position: position,
            rotation: Vector(0, 1),
            speed: 0,
            maximumSpeed: 1.5
        )
        super.init()
        
        agent.behaviorsDataSource = self
        agent.updatingDelegate = self
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
    
    func update(currentTime: TimeInterval, frameCount: Int){
        self.frameCount = frameCount
    }
}

extension AgentNode: SteeringAgentUpdatingDelegate {
    func willAgentUpdate(agent: SteeringAgent) {
        agent.position = Vector(position)
    }
    
    func didAgentUpdate(agent: SteeringAgent) {
        self.position = CGPoint(agent.position)
        
        if frameCount % 15 == 0 {
            self.zRotation = CGFloat(agent.rotation.angle - Float.pi / 2)
        }
    }
}

extension AgentNode: SteeringAgenetBehaviorsDataSource {
    func behaviors(of agent: SteeringAgent, isGroupLeader: Bool, hasAchieved: Bool)
        -> [SteeringBehavior]
    {
        
        switch (isGroupLeader, hasAchieved) {
        case (_, true):
            return [
                .separation(weight: 0.4, visibleDistance: 33),
            ]
            
        case (true, _):
            return [
                .seeking(weight: 0.18, visibleDistance: 10000),
                .separation(weight: 0.2, visibleDistance: 33),
            ]
        default:
            return [
                .seeking(weight: 0.004, visibleDistance: 10000),
                .seeking(weight: 0.012, visibleDistance: 300),
                .cohesion(weight: 0.001, visibleDistance: 100),
                .separation(weight: 0.015, visibleDistance: 66),
                .separation(weight: 0.2, visibleDistance: 33),
                .alignment(weight: 0.008, visibleDistance: 150)
            ]
        }
    }
}

extension Vector {
    init(_ point: CGPoint) {
        self.init(Float(point.x), Float(point.y))
    }
}

extension CGPoint {
    init(_ vector: Vector) {
        self.init(x: CGFloat(vector.x), y: CGFloat(vector.y))
    }
}

