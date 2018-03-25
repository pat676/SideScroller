//
//  MuzzleNode.swift
//  RocketMan
//
//  Created by Patrick Henriksen on 25.03.2018.
//  Copyright © 2018 Patrick Henriksen. All rights reserved.
//

import SpriteKit

class MuzzleNode: SKSpriteNode{
    
    static let muzzleAnimation = SKNode.createAnimation(from: "Muzzle", timePerFrame: STANDARD_TIME_PER_FRAME)
        
    //MARK: - System
    convenience init(){
        self.init(imageNamed: "PlayerMuzzle")
        name = "Muzzle"
    }
    
    static func didReceiveMemoryWarning(){
        _reusableNodes.reset()
    }
    
    //MARK: - ReusableNodes
    
    private static var _reusableNodes = ReusableNodes<MuzzleNode>(label: "MuzzleNodeQueue")
    
    static func dequeReusableNode() -> MuzzleNode{
        var node: MuzzleNode! = _reusableNodes.deque()
        if(node == nil || node.parent != nil){
            node = MuzzleNode()
        }
        
        //Scalling to bullet size first so the sensor points are calculated correctly
        node.startAnimation()
        return node
    }
    
    static func queueReusableNode(_ node: MuzzleNode){
        _reusableNodes.queue(node)
    }
    
    override func removeFromParent() {
        super.removeFromParent()
        removeAllActions()
        MuzzleNode.queueReusableNode(self)
    }
    
    //MARK: - Animation
    
    func startAnimation(){
        let completion = SKAction.customAction(withDuration: 0){_,_ in self.removeFromParent()}
        let sequence = SKAction.sequence([MuzzleNode.muzzleAnimation, completion])
        run(sequence)
    }
}
