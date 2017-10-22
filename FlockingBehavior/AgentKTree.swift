//
//  PointKTree.swift
//  FlockingBehavior
//
//  Created by Quoc Dung Chu on 21/10/2017.
//  Copyright © 2017 quoc. All rights reserved.
//
import Foundation

class AgentKTree {
    
    typealias OnQueriedAgent = (Agent) -> Void
    
    enum Constans {
        static let defaultMaxLeafSize = 1
    }
    
    struct Zone {
        let min: Vector
        let max: Vector
        
        var isVertical: Bool {
            return max.x - min.x > max.y - min.y
        }
        
        var center: Vector {
            return (max - min) * 0.5 + min
        }
        
        init(min: Vector = Vector.zero, max: Vector = Vector.zero) {
            self.min = min
            self.max = max
        }
    }
    
    struct Node {
        let begin: Int
        let end: Int
        let left: Int?
        let right: Int?
        let zone: Zone?
        
        init(begin: Int = 0, end: Int = 0, left: Int? = nil, right: Int? = nil, zone: Zone? = nil) {
            self.begin = begin
            self.end = end
            self.left = left
            self.right = right
            self.zone = zone
        }
    }
    
    var agents: [Agent]
    var nodes: [Node?]
    let maxLeafSize: Int
    
    init(agents: [Agent], maxLeafSize: Int = Constans.defaultMaxLeafSize) {
        self.agents = agents
        self.maxLeafSize = maxLeafSize
        self.nodes = [Node?](repeating: nil, count: 2 * agents.count - 1)
        buildNodes()
    }
    
    func buildNodes(){
        guard !agents.isEmpty else {
            return
        }
        
        buildNodesRecursive(begin: 0, end: agents.count, forIndex: 0)
    }
    
    func buildNodesRecursive(begin: Int, end: Int, forIndex index: Int) {
        
        guard maxLeafSize < end - begin else {
            nodes[index] = Node(
                begin: begin,
                end: end
            )
            return
        }
        
        let zone = findNodeZone(begin: begin, end: end, forIndex: index)
        
        let isVertical = zone.isVertical
        
        let pivot = isVertical ? zone.center.x: zone.center.y
        
        var left = begin
        var right = end
            
        while left < right {
            
            while left < right
                && (isVertical ? agents[left].position.x: agents[left].position.y) < pivot
            {
                left += 1
            }
            
            while right > left
                && (isVertical ? agents[right - 1].position.x: agents[right - 1].position.y) >= pivot
            {
                right -= 1
            }
            
            if left < right {
                agents.swapAt(left, right - 1)
                left += 1
                right -= 1
            }
        }
        
        if left == begin {
            left += 1
            right += 1
        }
        
        let nodeLeft = index + 1
        let nodeRight = index + 2 * (left - begin)
        
        nodes[index] = Node(
            begin: begin,
            end: end,
            left: nodeLeft,
            right: nodeRight,
            zone: zone
        )
        
        buildNodesRecursive(begin: begin, end: left, forIndex: nodeLeft)
        buildNodesRecursive(begin: left, end: end, forIndex: nodeRight)
    }
    
    func findNodeZone(begin: Int, end: Int, forIndex index: Int) -> Zone {
        var minX = agents[begin].position.x
        var minY = agents[begin].position.y
        var maxX = agents[begin].position.x
        var maxY = agents[begin].position.y

        for i in (begin + 1)..<end {
            let position = agents[i].position
            minX = min(minX, position.x)
            minY = min(minY, position.y)
            maxX = max(maxX, position.x)
            maxY = max(maxY, position.y)
        }
        
        return Zone(min: Vector(minX, minY), max: Vector(maxX, maxY))
    }
    
    func queryAgents(point: Vector, range: Float, onQueriedAgent: OnQueriedAgent) {
        queryAgentRecursive(
            point: point,
            squaredRange: sqr(range),
            nodeIndex: 0,
            onQueriedAgent: onQueriedAgent
        )
    }
    
    func queryAgentRecursive(
        point: Vector,
        squaredRange: Float,
        nodeIndex: Int,
        onQueriedAgent: OnQueriedAgent)
    {
        guard let node = nodes[nodeIndex] else {
            return
        }
        
        guard let left = node.left,
            let right = node.right,
            let leftZone = nodes[left]?.zone,
            let rightZone = nodes[right]?.zone,
            maxLeafSize < node.end - node.begin else
        {
            
            for i in node.begin..<node.end {
                onQueriedAgent(agents[i])
            }
            
            return
        }
        
        let squaredDistanceToLeftZone = AgentKTree.squaredDistance(fromPoint: point, toZone: leftZone)
        let squaredDistanceToRightZone = AgentKTree.squaredDistance(fromPoint: point, toZone: rightZone)

        if squaredDistanceToLeftZone < squaredDistanceToRightZone {
            if squaredDistanceToLeftZone < squaredRange {
                queryAgentRecursive(
                    point: point,
                    squaredRange: squaredRange,
                    nodeIndex: left,
                    onQueriedAgent: onQueriedAgent
                )
                
                if squaredDistanceToRightZone < squaredRange {
                    queryAgentRecursive(
                        point: point,
                        squaredRange: squaredRange,
                        nodeIndex: right,
                        onQueriedAgent: onQueriedAgent
                    )
                }
            }
        } else {
            if squaredDistanceToRightZone < squaredRange {
                queryAgentRecursive(
                    point: point,
                    squaredRange: squaredRange,
                    nodeIndex: right,
                    onQueriedAgent: onQueriedAgent
                )
                
                if squaredDistanceToLeftZone < squaredRange {
                    queryAgentRecursive(
                        point: point,
                        squaredRange: squaredRange,
                        nodeIndex: left,
                        onQueriedAgent: onQueriedAgent
                    )
                }
            }
        }
    }
    
    static func squaredDistance(fromPoint point: Vector, toZone zone: Zone) -> Float {
        return sqr(max(0.0, (zone.min.x - point.x)))
            + sqr(max(0.0, (point.x - zone.max.x)))
            + sqr(max(0.0, (zone.min.y - point.y)))
            + sqr(max(0.0, (point.y - zone.max.y)))
    }
}
