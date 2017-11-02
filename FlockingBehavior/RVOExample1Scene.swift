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
    var simulator: RVOOptimalSimulator!
    var agentNodes = [RVOAgentNode]()
    
    var previousTime: Double?
    
    override func didMove(to view: SKView) {
        addNodes()
    }
    
    func reset(){
        removeNodes()
        addNodes()
        update()
    }
    
    func nextStep(timeStep: Double){
        simulator.printVisualisationForDebug()
        computeAgents(timeStep: timeStep)
        update()
    }
    
    func nextStep(){
        simulator.printVisualisationForDebug()
        computeAgents(timeStep: simulator.timeStep)
        update()
    }
    
    private func addNodes(){
        simulator = RVOOptimalSimulator.makeWithAgentsInCircle(
            radius: 20.0,
            numberOfAgents: 13,
            maxNeightborDistance: 3,
            neighborsLeafSize: 10,
            agentRadius: 1.0,
            agentMaxSpeed: 1.0,
            timeNoCollision: 2.0,
            timeStep: 0.25
        )
        
        agentNodes = simulator.agents.map {
            RVOAgentNode(agent: $0)
        }
        
//        agentAvoidanceNode = RVOAvoidanceNode(
//            agent: simulator.agents[0],
//            neighbors: simulator.neighbors(of: simulator.agents[0]),
//            timeNoCollision: simulator.timeNoCollision,
//            timeStep: simulator.timeStep,
//            destinationPoint: simulator.destinations[0]
//        )

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
        //agentAvoidanceNode.removeFromParent()
        
        simulator.removeAll()
    }
    
    private func computeAgents(timeStep: Double){
        simulator.computeAgents(timeStep: timeStep)
    }
    
    private func update(){
        agentNodes.forEach { $0.update() }
        //agentAvoidanceNode.update()
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        if let previousTime = previousTime {
            nextStep(timeStep: currentTime - previousTime)
        }
        
        self.previousTime = currentTime
    }
}
