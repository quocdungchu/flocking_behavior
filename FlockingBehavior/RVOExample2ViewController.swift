//
//  RVOExample2ViewController.swift
//  FlockingBehavior
//
//  Created by Quoc Dung Chu on 04/11/2017.
//  Copyright © 2017 quoc. All rights reserved.
//

import UIKit
import SpriteKit

class RVOExample2ViewController: UIViewController {
    
    var scene: RVOExample2Scene!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as? SKView {
            self.scene = RVOExample2Scene(size: self.view.bounds.size)
            scene.backgroundColor = UIColor.white
            scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
            
            // Present the scene
            view.presentScene(scene)
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    @IBAction func tapOnSegment(sender: UISegmentedControl){
        switch sender.selectedSegmentIndex {
        case 0:
            scene.resetInCircle()
            
        case 1:
            scene.resetInBlock()
            
        default:
            break
        }
    }
}
