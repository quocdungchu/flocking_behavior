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
    enum Constants {
        static let scale: Float = 60.0
        static let timeNoCollision: Double = 6.0
        static let timeStep: Double = 0.25
        static let agentColor = UIColor.green
    }
    var agentAvoidanceNode: RVOAvoidanceNode!
    var simulator: RVOSimulator!
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
        computeAgents(timeStep: Constants.timeStep)
        update()
    }
    
    private func addNodes(){
        let simulator = RVOSimpleSimulator(
            timeNoCollision: Constants.timeNoCollision
        )
        
        simulator.addAgentInCircle(
            radius: 5.0,
            numberOfAgents: 2,
            agentRadius: 1.0,
            agentMaxSpeed: 1.0
        )
        
        agentNodes = simulator.agents.map {
            RVOAgentNode(agent: $0, scale: Constants.scale, color: Constants.agentColor)
        }
        
        agentAvoidanceNode = RVOAvoidanceNode(
            agent: simulator.agents[0],
            neighbors: simulator.neighbors(of: simulator.agents[0]),
            scale: Constants.scale,
            timeNoCollision: simulator.timeNoCollision,
            timeStep: Constants.timeStep,
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
    
    private func computeAgents(timeStep: Double){
        simulator.computeAgents(timeStep: timeStep)
    }
    
    private func update(){
        agentNodes.forEach { $0.update() }
        agentAvoidanceNode.update()
    }
}
