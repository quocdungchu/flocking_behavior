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
    
    enum Constants {
        static let scale: Float = 10.0
        static let agentColor = UIColor.green
    }
    
    var simulator: RVOOptimalSimulator!
    var agentNodes = [RVOAgentNode]()
    
    var previousTime: Double?
    
    override func didMove(to view: SKView) {
        resetSimulatorInCircle()
        addNodes()
    }
    
    func resetInCircle(){
        removeNodes()
        resetSimulatorInCircle()
        addNodes()
        update()
    }
    
    func resetInBlock(){
        removeNodes()
        resetSimulatorInBlock()
        addNodes()
        update()
    }
    
    private func resetSimulatorInCircle() {
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
    }
    
    func resetSimulatorInBlock() {
        simulator = RVOOptimalSimulator(
            maxNeightborDistance: 15,
            neighborsLeafSize: 10,
            timeNoCollision: 4.0,
            timeStep: 0.25
        )
        
        let blockDefinition = RVOSimulatorBlockDefinition(numberAgentInHorizontal: 4, numberAgentInVertical: 4, distanceBetweenAgent: 5.0)
        
        let agentDefinition = RVOSimulatorAgentDefinition(radius: 1.0, maxSpeed: 1.0)
        
        simulator.addAgentInBlock(
            blockDefinition: blockDefinition,
            agentDefinition: agentDefinition,
            agentBlockPositions: [Vector(10.0, -10.0), Vector(-30.0, -10.0)],
            destinationBlockPositions: [Vector(-30.0, -10.0), Vector(10.0, -10.0)]
        )
    }
    
    private func nextStep(timeStep: Double){
        simulator.printVisualisationForDebug()
        computeAgents(timeStep: timeStep)
        update()
    }
    
    private func addNodes() {
        
        agentNodes = simulator.agents.map {
            RVOAgentNode(agent: $0, scale: Constants.scale, color: Constants.agentColor)
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
