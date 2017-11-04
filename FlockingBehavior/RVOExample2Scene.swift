//
//  RVOExample2Scene.swift
//  FlockingBehavior
//
//  Created by Quoc Dung Chu on 04/11/2017.
//  Copyright © 2017 quoc. All rights reserved.
//

import UIKit
import SpriteKit

class RVOExample2Scene: SKScene {
    
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
    
    private func addNodes(){
        simulator = RVOOptimalSimulator(
            maxNeightborDistance: 3,
            neighborsLeafSize: 10,
            timeNoCollision: 2.0,
            timeStep: 0.25
        )

        simulator.addAgentInCircle(
            radius: 20.0,
            numberOfAgents: 13,
            agentRadius: 1.0,
            agentMaxSpeed: 1.0
        )
        
        agentNodes = simulator.agents.map {
            RVOAgentNode(agent: $0)
        }
        
        agentNodes.forEach {
            self.addChild($0)
        }
    }
    
    private func removeNodes(){
        agentNodes.forEach {
            $0.removeFromParent()
        }
        agentNodes.removeAll()
        
        simulator.removeAll()
    }
    
    private func computeAgents(timeStep: Double){
        simulator.computeAgents(timeStep: timeStep)
    }
    
    private func update(){
        agentNodes.forEach { $0.update() }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        if let previousTime = previousTime {
            nextStep(timeStep: currentTime - previousTime)
        }
        
        self.previousTime = currentTime
    }
}
