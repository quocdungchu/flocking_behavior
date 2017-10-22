//
//  AgentKTreeTests.swift
//  FlockingBehaviorTests
//
//  Created by Quoc Dung Chu on 21/10/2017.
//  Copyright © 2017 quoc. All rights reserved.
//

import XCTest
@testable import FlockingBehavior

class AgentKTreeTests: XCTestCase {
    
    func testBuildNodes(){
        let kTree = AgentKTree(agents: [
            Agent(position: Vector(2,0)),
            Agent(position: Vector.zero),
            Agent(position: Vector(1,0)),
        ])
        
        XCTAssertEqual(0, 0)
    }
}
