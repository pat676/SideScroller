//
//  MuzzleNode.swift
//  RocketMan
//
//  Created by Patrick Henriksen on 25.03.2018.
//  Copyright © 2018 Patrick Henriksen. All rights reserved.
//

import SpriteKit

class MuzzleNode: SKSpriteNode{
    
    static let muzzleAnimation = SKNode.createAnimation(from: "PlayerMuzzle", timePerFrame: STANDARD_TIME_PER_FRAME)
        
    //MARK: - System
    convenience init(){
        self.init(imageNamed: "PlayerMuzzle")
        scale(to: PLAYER_MUZZLE_SIZE)
        name = "PlayerMuzzle"
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
        
        node.startAnimation()
        return node
    }
    
    static func queueReusableNode(_ node: MuzzleNode){
        node.removeAllActions()
        _reusableNodes.queue(node)
    }
    
    static func preloadReusableNodes(amount: Int){
        for _ in 0..<amount{
            let node = MuzzleNode();
            queueReusableNode(node)
        }
    }
    
    override func removeFromParent() {
        super.removeFromParent()
        MuzzleNode.queueReusableNode(self)
    }
    
    //MARK: - Animation
    
    func startAnimation(){
        let completion = SKAction.customAction(withDuration: 0){_,_ in self.removeFromParent()}
        let sequence = SKAction.sequence([MuzzleNode.muzzleAnimation, completion])
        run(sequence)
    }
}
