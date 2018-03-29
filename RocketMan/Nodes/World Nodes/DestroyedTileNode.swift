//
//  DestroyedTileNode.swift
//  RocketMan
//
//  Created by Patrick Henriksen on 25.03.2018.
//  Copyright © 2018 Patrick Henriksen. All rights reserved.
//

import SpriteKit

class DestroyedTileNode: PhysicsNode{
    
    //MARK: - Properties
    
    var startVelocity: CGPoint!
    var rotateAction: SKAction!

    //MARK: - System
    convenience init(){
        self.init(imageNamed: "GroundMidMid1.png")
        name = "DestroyedTile"
        
        isAffectedByGravity = true

        size = CGSize(width: TILE_SIZE*DESTROYED_TILE_SIZE_MULTIPLIER, height: TILE_SIZE*DESTROYED_TILE_SIZE_MULTIPLIER);
        randomVelocity(max: DESTROYED_TILE_MAX_VELOCITY)
        randomRotation()
        
        alpha = DESTROYED_TILE_ALPHA
    }
    
    //MARK: - Random random Initializations
    
    //Sets a random velocity and angle with max velocity equal to max. 
    func randomVelocity(max: UInt32){
        let pi = CGFloat(Double.pi)
        var angle = CGFloat(arc4random_uniform(361))
        angle = angle*2*pi/360
        
        velocity = CGPoint(x: cos(angle), y: sin(angle))
        velocity = velocity * CGFloat(arc4random_uniform(max))
        startVelocity = velocity
    }
    
    func randomRotation(){
        let pi = CGFloat(Double.pi)
        var angle = CGFloat(arc4random_uniform(361))
        angle = angle*2*pi/360
        let rotateAction = SKAction.rotate(byAngle: angle, duration: 0.2)
        let rotateForeverAction = SKAction.repeatForever(rotateAction)
        self.rotateAction = rotateForeverAction
        run(rotateForeverAction)
    }
    
    //MARK: - Reusable Nodes
    
    static func didReceiveMemoryWarning(){
        _reusableNodes.reset()
    }
    
    private static var _reusableNodes = ReusableNodes<DestroyedTileNode>(label: "DestroyedTileNodeQueue")
    
    static func dequeReusableNode() -> DestroyedTileNode{
        var node: DestroyedTileNode! = _reusableNodes.deque()
        if(node == nil || node.parent != nil){
            node = DestroyedTileNode()
        }
        
        node.velocity = node.startVelocity
        node.run(node.rotateAction)
        return node
    }
    
    static func queueReusableNode(_ node: DestroyedTileNode){
        node.removeAllActions()
        _reusableNodes.queue(node)
    }
    
    static func preloadReusableNodes(amount: Int){
        for _ in 0..<amount{
            let node = DestroyedTileNode();
            queueReusableNode(node)
        }
    }
    
    override func removeFromParent() {
        super.removeFromParent()
        DestroyedTileNode.queueReusableNode(self)
    }

}
