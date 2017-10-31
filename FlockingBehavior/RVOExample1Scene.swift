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
    let simulator = RVOSimulator(noCollisionDeltaTime: 2.0, timeStep: 1.0)
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
        
        simulator.add(
            agent: Agent(
                position: Vector(5.0, 0.0),
                radius: 1.0,
                maxSpeed: 0.5
            ),
            destination: Vector(-5.0, 0)
        )
        
        simulator.add(
            agent: Agent(
                position: Vector(-5.0, 0.0),
                radius: 1.0,
                maxSpeed: 0.5
            ),
            destination: Vector(5.0, 0)
        )
        
        agentNodes = simulator.agents.map {
            RVOAgentNode(agent: $0)
        }
        
        agentAvoidanceNode = RVOAvoidanceNode(
            agent: simulator.agents[0],
            neighbors: simulator.agents.filter { $0 !== simulator.agents[0] },
            noCollisionDeltaTime: simulator.noCollisionDeltaTime,
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
    }
    
    private func computeAgents(){
        simulator.computeAgents()
    }
    
    private func update(){
        agentNodes.forEach { $0.update() }
        agentAvoidanceNode.update()
    }
}
