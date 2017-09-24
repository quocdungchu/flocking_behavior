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
    
    var agentNodes = [AgentNode]()
    
    var frameCount = 0
    
    override func didMove(to view: SKView) {
        
        for rangIndex in -1...1 {
            for colIndex in -1...1 {
                
                let position = Vect2.zero + (Vect2(Float(rangIndex), Float(colIndex)) * 50)
                let agentNode = AgentNode(position: position)
                agentNode.agent.delegate = self
                addChild(agentNode)
                
                agentNodes.append(agentNode)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        seekingPosition = Vect2(touch.location(in: self))
    }
    
    override func update(_ currentTime: TimeInterval) {
        agentNodes.forEach {
            $0.update(elapsedTime: currentTime, frameCount: frameCount)
        }
        
        frameCount += 1
    }
}

extension GameScene: AgentDelegate {
    func findSeekingPosition(by agent: Agent) -> Vect2? {
        return seekingPosition
    }
    
    func findOtherAgentsPositions(within visibleDistance: Float, by agent: Agent) -> [Vect2] {
        return agentNodes.filter { $0.agent !== agent }
            .filter { agent.position.distance(to: $0.agent.position) <= visibleDistance }
            .map { $0.agent.position }
    }
    
    func findOtherAgentsVelocities(within visibleDistance: Float, by agent: Agent) -> [Vect2] {
        return agentNodes.filter { $0.agent !== agent }
            .filter { agent.position.distance(to: $0.agent.position) <= visibleDistance }
            .map { $0.agent.velocity }
    }
    
    func canStop(agent: Agent) -> Bool {
        
        guard let seekingPosition = seekingPosition else {
            return true
        }
        
        let allPositions = agentNodes.map { $0.agent.position }
        
        let center = average(of: allPositions)
        return center.distance(to: seekingPosition) < MaximumDistanceToStop
    }
}
