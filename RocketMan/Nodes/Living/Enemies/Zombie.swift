//
//  Zombie.swift
//  RocketMan
//
//  Created by Patrick Henriksen on 27.03.2018.
//  Copyright © 2018 Patrick Henriksen. All rights reserved.
//

import SpriteKit

class Zombie: Enemy{
    
    //MARK: - Properties
    
    var idleAction: SKAction!
    var walkAction: SKAction!
    
    //MARK: - System
    
    convenience init(){
        self.init(imageNamed: "ZombieIdle_1.png")

        name = "Zombie"
        physicsFrameScale = ZOMBIE_PHYSICS_FRAME_SCALE
        
        speed = ZOMBIE_SPEED
        viewDistance = ZOMBIE_VIEW_DISTANCE
        getVelocity = velocityAI.simpleVelocity
    }
    
    static func didReceiveMemoryWarning(){
        _reusableNodes.reset()
    }
    
    //MARK: - Animations
    
    override func addAnimations(){
        let atlas = textureAtlasManager.zombieAtlas
        idleAction = SKNode.createAnimation(from: atlas, animationName: "ZombieIdle", timePerFrame: ZOMBIE_IDLE_TIME_PER_FRAME)
        walkAction = SKNode.createAnimation(from: atlas, animationName: "ZombieWalk", timePerFrame: ZOMBIE_MOVE_TIME_PER_FRAME)
    }
    
    override func updateAnimation() {
        super.updateAnimation()
        if(currentAction == .Idle){
            run(SKAction.repeatForever(idleAction))
        }
        else if(currentAction == .Moving){
            run(SKAction.repeatForever(walkAction))
        }
    }
    
    //MARK: - Reusable Nodes
    
    private static var _reusableNodes = ReusableNodes<Zombie>(label: "EnemyNodeQueue")
    
    static func dequeReusableNode() -> Zombie{
        var node: Zombie! = _reusableNodes.deque()
        if(node == nil || node.parent != nil){
            node = Zombie()
        }

        node.currentAction = .Idle
        node.updateAnimation()
        return node
    }
    
    static func queueReusableNode(_ node: Zombie){
        node.removeAllActions()
        _reusableNodes.queue(node)
    }
    
    static func preloadReusableNodes(amount: Int){
        for _ in 0..<amount{
            let node = Zombie();
            queueReusableNode(node)
        }
    }
    
    override func removeFromParent() {
        super.removeFromParent()
        Zombie.queueReusableNode(self)
    }
}
