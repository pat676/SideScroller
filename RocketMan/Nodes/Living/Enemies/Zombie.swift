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
        getVelocity = velocityAI.simpleVelocity
        hasCloseAttack = true
        zPosition = 101
    }
    
    //MARK: - Animations
    
    override func addAnimations(){
        let atlas = textureAtlasManager.zombieAtlas
        idleAnimation = SKNode.createAnimation(from: atlas, animationName: "ZombieIdle", timePerFrame: ZOMBIE_IDLE_TIME_PER_FRAME)
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
            bloodEmitter = newBloodEmitter()
        }
        guard bloodEmitter != nil else {return}
        bloodEmitter!.position.x = size.width * ZOMBIE_BLOOD_POSITION.x
        bloodEmitter!.position.y = size.height * ZOMBIE_BLOOD_POSITION.y
        bloodEmitter!.zPosition = -1
        addChild(bloodEmitter!)
    }
    
    func removeBloodEmitter(){
        bloodEmitter?.removeFromParent()
    }
    
    //MARK: - Death
    
    override func killedAnimated(forceDirection: CGPoint) {
        currentAction = .Dying
    }
}
