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
    var idleAnimation: SKAction!
    var walkAnimation: SKAction!
    var attackAnimation: SKAction!
    var deathAnimation: SKAction!

    var bloodEmitter: SKEmitterNode?
    
    //MARK: - System
    
    convenience init(){
        self.init(imageNamed: "ZombieIdle_1.png")

        name = "Zombie"
        physicsFrameScale = ZOMBIE_PHYSICS_FRAME_SCALE
        
        speed = ZOMBIE_SPEED
        damage = ZOMBIE_DAMAGE
        pushback = ZOMBIE_PUSHBACK
        viewDistance = ZOMBIE_VIEW_DISTANCE
        health = ZOMBIE_HEALTH
        
        getVelocity = velocityAI.simpleVelocity
        hasCloseAttack = true
        zPosition = 101
    }
    
    func reset(){
        health = ZOMBIE_HEALTH
        
        zRotation = 0
        currentAction = .Idle
        updateAnimation()
        isAffectedByWorldSolids = true
        shouldUpdateFacing = true
        continuesRotationAngle = 0
        continuesRotationTime = 0
        anchorPoint = CGPoint.zero
        getVelocity = velocityAI.simpleVelocity
        hasCloseAttack = true
        zPosition = 101
    }
    
    //MARK: - Animations
    
    override func addAnimations() {
        let atlas = SKTextureAtlas(named: "Zombie@2x")
        idleAnimation = SKNode.createAnimation(from: atlas, animationName: "ZombieIdle", timePerFrame: ZOMBIE_MOVE_TIME_PER_FRAME)
        walkAnimation = SKNode.createAnimation(from: atlas, animationName: "ZombieWalk", timePerFrame: ZOMBIE_MOVE_TIME_PER_FRAME)
        attackAnimation = SKNode.createAnimation(from: atlas, animationName: "ZombieAttack", timePerFrame: ZOMBIE_MOVE_TIME_PER_FRAME)
        deathAnimation = SKNode.createAnimation(from: atlas, animationName: "ZombieDead", timePerFrame: ZOMBIE_MOVE_TIME_PER_FRAME)
    }
    
    override func updateAnimation() {
        super.updateAnimation()
        if(currentAction == .Idle){
            removeBloodEmitter()
            run(SKAction.repeatForever(idleAnimation), withKey: "Animation")
        }
        else if(currentAction == .Moving){
            removeBloodEmitter()
            run(SKAction.repeatForever(walkAnimation), withKey: "Animation")
        }
        else if(currentAction == .CloseAttack){
            addBloodEmitter()
            run(SKAction.repeatForever(attackAnimation), withKey: "Animation")
        }
        else if(currentAction == .Dying){
            let removeAction = SKAction.customAction(withDuration: 0){_,_ in self.removeFromParent()}
            let sequence = SKAction.sequence([deathAnimation, removeAction])
            run(sequence, withKey:"Animation")
        }
    }
    
    func addBloodEmitter(){
        if(bloodEmitter == nil){
            bloodEmitter = BloodEmitter.dequeReusableNode()
        }
        guard bloodEmitter != nil else {return}
        bloodEmitter!.position.x = size.width * ZOMBIE_BLOOD_POSITION.x
        bloodEmitter!.position.y = size.height * ZOMBIE_BLOOD_POSITION.y
        bloodEmitter!.zPosition = -1
        addChild(bloodEmitter!)
    }
    
    func removeBloodEmitter(){
        if let node = bloodEmitter{
            BloodEmitter.removeNode(node: node)
        }
    }
    
    //MARK: - Death
    
    override func killedAnimated(forceDirection: CGPoint) {
        currentAction = .Dying
    }
    
    //MARK: - Reusable Nodes
    
    private static var _reusableNodes = ReusableNodes<Zombie>(label: "ZombieNodeQueue")
    
    static func resetReusableNodes(){
        _reusableNodes.reset()
    }
    
    static func dequeReusableNode() -> Zombie{
        var node: Zombie! = _reusableNodes.deque()
        if(node == nil || node.parent != nil){
            node = Zombie()
        }
        node.reset()
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
