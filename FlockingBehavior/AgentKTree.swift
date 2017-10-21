//
//  PointKTree.swift
//  FlockingBehavior
//
//  Created by Quoc Dung Chu on 21/10/2017.
//  Copyright © 2017 quoc. All rights reserved.
//
import Foundation

class AgentKTree {
    
    enum Constans {
        static let maxLeafSize = 10
    }
    
    struct Zone {
        let min: Vector
        let max: Vector
        
        var isVertical: Bool {
            return max.x - min.x > max.y - min.y
        }
        
        var center: Vector {
            return (max - min) * 0.5
        }
        
        init(){
            self.min = Vector.zero
            self.max = Vector.zero
        }
        
        init(min: Vector, max: Vector) {
            self.min = min
            self.max = max
        }
    }
    
    struct Node {
        let begin: Int
        let end: Int
        let left: Int
        let right: Int
        let zone: Zone
        
        init(){
            self.begin = 0
            self.end = 0
            self.left = 0
            self.right = 0
            self.zone = Zone()
        }
        
        init(begin: Int, end: Int, left: Int, right: Int, zone: Zone) {
            self.begin = begin
            self.end = end
            self.left = left
            self.right = right
            self.zone = zone
        }
    }
    
    var agents: [Agent]
    var nodes: [Node]
    
    init(agents: [Agent]) {
        self.agents = agents
        self.nodes = [Node](repeating: Node(), count: agents.count)
    }
    
    func buildNodes(){
        guard !agents.isEmpty else {
            return
        }
        
        buildNodesRecursive(begin: 0, end: agents.count - 1, forIndex: 0)
    }
    
    func buildNodesRecursive(begin: Int, end: Int, forIndex index: Int) {
        
        let zone = findNodeZone(begin: begin, end: end, forIndex: index)
        
        if Constans.maxLeafSize < (end - begin) + 1 {
            let isVertical = zone.isVertical
            
            let splitValue = isVertical ? zone.center.x: zone.center.y
            
            var left = begin
            var right = end
            
            while left < right {
                
                while left < right
                    && (isVertical ? agents[left].position.x: agents[left].position.y) < splitValue
                {
                    left += 1
                }
                
                while right > left
                    && (isVertical ? agents[right].position.x: agents[right].position.y) >= splitValue
                {
                    right -= 1
                }
                
                if left < right {
                    agents.swapAt(left, right)
                    left += 1
                    right -= 1
                }
                
                if left == begin {
                    left += 1
                    right += 1
                }
                
                nodes[index] = Node(
                    begin: begin,
                    end: end,
                    left: index + 1,
                    right: index + 2 * ( left - begin),
                    zone: zone
                )
                
                buildNodesRecursive(begin: begin, end: left, forIndex: nodes[index].left)
                buildNodesRecursive(begin: left, end: end, forIndex: nodes[index].right)
            }
        }
    }
    
    func findNodeZone(begin: Int, end: Int, forIndex index: Int) -> Zone {
        var minX = agents[index].position.x
        var minY = agents[index].position.y
        var maxX = agents[index].position.x
        var maxY = agents[index].position.y

        for i in begin...end {
            let position = agents[i].position
            minX = min(minX, position.x)
            minY = min(minY, position.y)
            maxX = max(maxX, position.x)
            maxY = max(maxY, position.y)
        }
        
        return Zone(min: Vector(minX, minY), max: Vector(maxX, maxY))
    }
}
