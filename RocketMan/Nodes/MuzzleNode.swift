//
//  MuzzleNode.swift
//  RocketMan
//
//  Created by Patrick Henriksen on 25.03.2018.
//  Copyright © 2018 Patrick Henriksen. All rights reserved.
//

import SpriteKit

class MuzzleNode: SKSpriteNode{
    
    //MARK: - System
    convenience init(){
        self.init(imageNamed: "PlayerMuzzle_1.png")

        name = "PlayerMuzzle"
        
        updateAnimation()
    }
    
    //MARK: - ReusableNodes
    
    private static var _reusableNodes = ReusableNodes<MuzzleNode>(label: "MuzzleNodeQueue")
    
    static func resetReusableNodes(){
        _reusableNodes.reset()
    }
    
    static func dequeReusableNode() -> MuzzleNode{
        var node: MuzzleNode! = _reusableNodes.deque()
        if(node == nil || node.parent != nil){
            node = MuzzleNode()
        }
        node.updateAnimation()
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
    
    func updateAnimation(){
        removeAllActions()
        let atlas = SKTextureAtlas(named: "Player@2x")
        let animation = SKNode.createAnimation(from: atlas, animationName: "PlayerMuzzle", timePerFrame: STANDARD_TIME_PER_FRAME)
        let removeAction = SKAction.customAction(withDuration: 0){_,_ in self.removeFromParent()}
        let muzzleAnimation = SKAction.sequence([animation, removeAction])
        run(SKAction.repeatForever(muzzleAnimation))
    }
}
