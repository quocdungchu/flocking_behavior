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
    
    var agentNode: AgentNode!
    
    override func didMove(to view: SKView) {
        self.agentNode = AgentNode()
        agentNode.agent.delegate = self
        addChild(agentNode)
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        seekingPosition = Vect2(touch.location(in: self))
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        agentNode.update(elapsedTime: currentTime)
    }
}

extension GameScene: AgentDelegate {
    func seekingPosition(for agent: Agent) -> Vect2? {
        return seekingPosition
    }
}
