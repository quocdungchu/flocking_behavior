//
//  RVOExample1ViewController.swift
//  FlockingBehavior
//
//  Created by Quoc Dung Chu on 29/10/2017.
//  Copyright © 2017 quoc. All rights reserved.
//

import UIKit
import SpriteKit

class RVOExample1ViewController: UIViewController {

    var scene: RVOExample1Scene?
    
    @IBOutlet var stepLabel: UILabel!
    
    var step: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLabel()

        if let view = self.view as? SKView {
            if let scene = SKScene(fileNamed: "RVOScene") as? RVOExample1Scene {
                self.scene = scene
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    func updateLabel(){
        stepLabel.text = "Step: \(step)"
    }
    
    @IBAction func nextStep(){
        scene?.nextStep()
        step += 1
        updateLabel()
    }
    
    @IBAction func reset(){
        scene?.reset()
        step = 0
        updateLabel()
    }
}
