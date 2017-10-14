//
//  KTree.swift
//  FlockingBehavior
//
//  Created by Quoc Dung Chu on 14/10/2017.
//  Copyright © 2017 quoc. All rights reserved.
//

import Foundation

class ObstacleKTree {
    
    class Node {
        let obstacle: Obstacle
        let left: Node?
        let right: Node?
        
        init(obstacle: Obstacle, left: Node? = nil, right: Node? = nil) {
            self.obstacle = obstacle
            self.left = left
            self.right = right
        }
    }
    
    struct OptimalSplit {
        let index: Int
        let leftCount: Int
        let rightCount: Int
    }
    
    struct SplitResult {
        let left: Obstacle
        let right: Obstacle
    }
    
    let obstacles: [Obstacle]
    fileprivate (set)  var node: Node?
    
    init(obstacles: [Obstacle]) {
        self.obstacles = obstacles
    }
    
    func build(){
        self.node = ObstacleKTree.buildRecursive(obstacles: obstacles)
    }
    
    static func buildRecursive(obstacles: [Obstacle]) -> Node? {
        guard !obstacles.isEmpty else {
            return nil
        }
        
        guard let optimalSplit = findOptimalSplitIndex(obstacles: obstacles) else {
            return nil
        }
        
        var leftObstacles = [Obstacle]()
        var rightObstacles = [Obstacle]()
        
        let obstacleI1 = obstacles[optimalSplit.index]
        let obstacleI2 = obstacleI1.next!
        
        for j in 0..<obstacles.count {
            guard optimalSplit.index != j else {
                continue
            }
            
            let obstacleJ1 = obstacles[j]
            let obstacleJ2 = obstacleJ1.next!
            
            let j1LeftOfI = leftOf(start: obstacleI1.point, end: obstacleI2.point, point: obstacleJ1.point)
            let j2LeftOfI = leftOf(start: obstacleI1.point, end: obstacleI2.point, point: obstacleJ2.point)
            
            if j1LeftOfI >= -RVO_EPSILON && j2LeftOfI >= -RVO_EPSILON {
                leftObstacles.append(obstacleJ1)
                
            } else if j1LeftOfI <= RVO_EPSILON && j2LeftOfI <= RVO_EPSILON {
                rightObstacles.append(obstacleJ1)

            } else {
                let splitPoint = intersection(
                    start1: obstacleI1.point,
                    end1: obstacleI2.point,
                    start2: obstacleJ1.point,
                    end2: obstacleJ2.point
                )!
                
                let newObstacle = Obstacle()
                newObstacle.point = splitPoint
                newObstacle.previous = obstacleJ1
                newObstacle.next = obstacleJ2
                newObstacle.convexe = true
                
                obstacleJ1.next = newObstacle
                obstacleJ2.previous = newObstacle
                
                if j1LeftOfI > 0 {
                    leftObstacles.append(obstacleJ1)
                    rightObstacles.append(newObstacle)

                } else {
                    rightObstacles.append(obstacleJ1)
                    leftObstacles.append(newObstacle)
                }
            }
        }
        
        let left = buildRecursive(obstacles: leftObstacles)
        let right = buildRecursive(obstacles: rightObstacles)
        
        return Node(obstacle: obstacleI1, left: left, right: right)
    }
        
    static func findOptimalSplitIndex(obstacles: [Obstacle]) -> OptimalSplit? {
        guard !obstacles.isEmpty else {
            return nil
        }
        
        var optimalSplitIndex = 0
        var minLeft = obstacles.count
        var minRight = obstacles.count
        
        for i in 0..<obstacles.count {
            
            let obstacleI1 = obstacles[i]
            let obstacleI2 = obstacleI1.next!
            
            var leftSize = 0
            var rightSize = 0
            
            for j in 0..<obstacles.count {
                guard i != j else {
                    continue
                }
                
                let obstacleJ1 = obstacles[j]
                let obstacleJ2 = obstacleJ1.next!

                let j1LeftOfI = leftOf(start: obstacleI1.point, end: obstacleI2.point, point: obstacleJ1.point)
                let j2LeftOfI = leftOf(start: obstacleI1.point, end: obstacleI2.point, point: obstacleJ2.point)

                if j1LeftOfI >= -RVO_EPSILON && j2LeftOfI >= -RVO_EPSILON {
                    leftSize += 1
                    
                } else if j1LeftOfI <= RVO_EPSILON && j2LeftOfI <= RVO_EPSILON {
                    rightSize += 1
                    
                } else {
                    leftSize += 1
                    rightSize += 1
                }
                
                if compare(leftFirst: max(leftSize, rightSize),
                    leftSecond: min(leftSize, rightSize),
                    rightFirst: max(minLeft, minRight),
                    rightSecond: min(minLeft, minRight)) >= 0
                {
                    break
                }
            }
            
            if compare(leftFirst: max(leftSize, rightSize),
               leftSecond: min(leftSize, rightSize),
               rightFirst: max(minLeft, minRight),
               rightSecond: min(minLeft, minRight)) < 0
            {
                minLeft = leftSize
                minRight = rightSize
                optimalSplitIndex = i
            }
        }
        
        return OptimalSplit(index: optimalSplitIndex, leftCount: minLeft, rightCount: minRight)
    }
}

private func compare(leftFirst: Int, leftSecond: Int, rightFirst: Int, rightSecond: Int) -> Int {
    if leftFirst < rightFirst {
        return -1
        
    } else if leftFirst > rightFirst {
        return 1
        
    } else if leftSecond < rightSecond {
        return -1
        
    } else if leftSecond > rightSecond {
        return 1
        
    } else {
        return 0
    }
}

