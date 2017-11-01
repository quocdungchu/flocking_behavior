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
    
    var currentTime: Double = 0
    
    override func didMove(to view: SKView) {
        addNodes()
    }
    
    func reset(){
        removeNodes()
        addNodes()
        update()
    }
    
    func nextStep(){
        simulator.printVisualisationForDebug()
        computeAgents()
        update()
    }
    
    private func addNodes(){
        simulator = RVOSimulator.makeWithAgentsInCircle(
            radius: 5.0,
            numberOfAgents: 10,
            maxNeightborDistance: 5,
            neighborsLeafSize: 10,
            agentRadius: 1.0,
            agentMaxSpeed: 4.0,
            timeNoCollision: 10.0,
            timeStep: 0.125
        )
        
        agentNodes = simulator.agents.map {
            RVOAgentNode(agent: $0)
        }
        
        agentAvoidanceNode = RVOAvoidanceNode(
            agent: simulator.agents[0],
            neighbors: simulator.neighbors(of: simulator.agents[0]),
            timeNoCollision: simulator.timeNoCollision,
            timeStep: simulator.timeStep,
            destinationPoint: simulator.destinations[0]
        )

        agentNodes.forEach {
            self.addChild($0)
        }
        
        //addChild(agentAvoidanceNode)
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
        //agentAvoidanceNode.update()
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        if currentTime - self.currentTime >= simulator.timeStep {
            nextStep()
            self.currentTime = currentTime
        }
    }
}
