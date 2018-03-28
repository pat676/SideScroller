//
//  GameViewController.swift
//  RocketMan
//
//  Created by Patrick Henriksen on 12.03.2018.
//  Copyright © 2018 Patrick Henriksen. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        presentScene()
    }
    
    func presentScene(){
        let scene = LoadingScene(size: CGSize(width: 2048, height: 1536))
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .aspectFill
        skView.presentScene(scene)
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func didReceiveMemoryWarning(){
        PlayerBulletNode.didReceiveMemoryWarning()
        DestroyedTileNode.didReceiveMemoryWarning()
        MuzzleNode.didReceiveMemoryWarning()
        Zombie.didReceiveMemoryWarning()
    }
}
