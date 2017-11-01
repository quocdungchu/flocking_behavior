//
//  RVOScene.swift
//  FlockingBehavior
//
//  Created by Quoc Dung Chu on 29/10/2017.
//  Copyright © 2017 quoc. All rights reserved.
//
import UIKit
import SpriteKit

class RVOExample1Scene: SKScene {
    
    var agentAvoidanceNode: RVOAvoidanceNode!
    var simulator: RVOSimulator!
    var agentNodes = [RVOAgentNode]()
    
    override func didMove(to view: SKView) {
        addNodes()
    }
    
    func reset(){
        removeNodes()
        addNodes()
        update()
    }
    
    func nextStep(){
        computeAgents()
        update()
    }
    
    private func addNodes(){
        simulator = RVOSimulator.makeWithAgentsInCircle(radius: 5.0, numberOfAgents: 3)
        
        agentNodes = simulator.agents.map {
            RVOAgentNode(agent: $0)
        }
        
        agentAvoidanceNode = RVOAvoidanceNode(
            agent: simulator.agents[0],
            neighbors: simulator.agents.filter { $0 !== simulator.agents[0] },
            timeNoCollision: simulator.timeNoCollision,
            timeStep: simulator.timeStep,
            destinationPoint: simulator.destinations[0]
        )

        agentNodes.forEach {
            self.addChild($0)
        }
        
        addChild(agentAvoidanceNode)
    }
    
    private func removeNodes(){
        agentNodes.forEach {
            $0.removeFromParent()
        }
        agentNodes.removeAll()
        agentAvoidanceNode.removeFromParent()
        
        simulator.removeAll()
    }
    
    private func computeAgents(){
        simulator.computeAgents()
    }
    
    private func update(){
        agentNodes.forEach { $0.update() }
        agentAvoidanceNode.update()
    }
}
