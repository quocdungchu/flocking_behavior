//
//  GameScene.swift
//  FlockingBehavior
//
//  Created by Quoc Dung Chu on 9/24/17.
//  Copyright © 2017 quoc. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
        
    let steeringManager = SteeringManager()
    
    var agentNodes = [AgentNode]()
    
    var frameCount = 0
    
    override func didMove(to view: SKView) {
        
        for rangIndex in -1...2 {
            for colIndex in -1...2 {
                
                let position = Vector.zero + (Vector(Float(rangIndex), Float(colIndex)) * 50)
                let agentNode = AgentNode(position: position)
                addChild(agentNode)
                
                agentNodes.append(agentNode)
                
                steeringManager.add(agent: agentNode.agent)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        steeringManager.move(
            agents: agentNodes.map { $0.agent },
            to: Vector(touch.location(in: self))
        )
    }
    
    override func update(_ currentTime: TimeInterval) {
        agentNodes.forEach {
            $0.update(currentTime: currentTime, frameCount: frameCount)
        }
        
        steeringManager.update(currentTime)
        
        frameCount += 1
    }
}
