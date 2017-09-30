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
    
    var seekingPosition: Vect2?
    
    let steeringManager = SteeringManager()
    
    var agentNodes = [AgentNode]()
    
    var frameCount = 0
    
    override func didMove(to view: SKView) {
        
        for rangIndex in -1...1 {
            for colIndex in -1...1 {
                
                let position = Vect2.zero + (Vect2(Float(rangIndex), Float(colIndex)) * 50)
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
        //seekingPosition = Vect2(touch.location(in: self))
        
        steeringManager.move(
            agents: agentNodes.map { $0.agent },
            to: Vect2(touch.location(in: self))
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

extension GameScene {
    func findSeekingPosition(by agent: SteeringAgent) -> Vect2? {
        return seekingPosition
    }
    
    func findOtherAgentsPositions(within visibleDistance: Float, by agent: SteeringAgent) -> [Vect2] {
        return agentNodes.filter { $0.agent !== agent }
            .filter { agent.position.distance(to: $0.agent.position) <= visibleDistance }
            .map { $0.agent.position }
    }
    
    func findOtherAgentsVelocities(within visibleDistance: Float, by agent: SteeringAgent) -> [Vect2] {
        return agentNodes.filter { $0.agent !== agent }
            .filter { agent.position.distance(to: $0.agent.position) <= visibleDistance }
            .map { $0.agent.velocity }
    }
    
    func canStop(agent: SteeringAgent) -> Bool {
        
        guard let seekingPosition = seekingPosition else {
            return true
        }
        return agent.position.distance(to: seekingPosition) < MaximumDistanceToStop
    }
}
