//
//  Player.swift
//  RocketMan
//
//  Created by Patrick Henriksen on 14.03.2018.
//  Copyright © 2018 Patrick Henriksen. All rights reserved.
//

import SpriteKit

class PlayerNode: Living{
    
    //MARK: - Properties
    
    var canShoot: Bool{get{ return !isDead && (currentAction == .Jumping || currentAction == .Moving)} }
    var canJump: Bool{get{return !isDead && isOnSolidGround && (currentAction != .Jumping && currentAction != .JumpShooting)}}
    
    
    //MARK: - Animation Actions
    
    var runAnimation: SKAction!
    var jumpAnimation: SKAction!
    var landAnimation: SKAction!
    var jumpShootAnimation: SKAction!
    var runShootAnimation: SKAction!
    var dyingAnimation: SKAction!
    
    //MARK: - System
    
    convenience init(playableRect: CGRect, playerMargin: CGFloat){
        self.init(imageNamed: "PlayerRun_1.png")

        zPosition = 100
        
        physicsFrameScale = PLAYER_PHYSICS_FRAME_SCALE
        position = CGPoint(x: playerMargin, y:playableRect.minY + TILE_SIZE + 500)
        currentAction = .Moving
    }
    
    //MARK: - Update
    
    func update(in cameraPlayableRect: CGRect){
        guard !isDead else {return}
        updatePlayerVelocity(in: cameraPlayableRect)
        if(!isOnSolidGround && currentAction != .Jumping && currentAction != .JumpShooting){
            //Fallen of a platform
            currentAction = .Jumping
        }
    }
    
    // Adjusts the velocity of the player. If the player is to far left/right the speed is increased/decreased
    func updatePlayerVelocity(in cameraPlayableRect: CGRect){
        guard !isDead else {return}
        if(position.x < cameraPlayableRect.minX + PLAYER_MARGIN - 10){
            velocity.x = (1+PLAYER_VELOCITY_OFF_MARGIN_MUL) * CAMERA_VELOCITY
        }
        else if(position.x > cameraPlayableRect.minX + PLAYER_MARGIN + 10){
            velocity.x = (1-PLAYER_VELOCITY_OFF_MARGIN_MUL) * CAMERA_VELOCITY
        }
        else if(position.x < cameraPlayableRect.minX + PLAYER_MARGIN + 5 && position.x > cameraPlayableRect.minX + PLAYER_MARGIN - 5){
            velocity.x = CAMERA_VELOCITY
        }
    }
    
    //MARK: - Animations
    
    override func addAnimations(){
        let atlas = SKTextureAtlas(named: "Player@2x")

        runAnimation = SKNode.createAnimation(from: atlas, animationName: "PlayerRun", timePerFrame: STANDARD_TIME_PER_FRAME)
        jumpAnimation = SKNode.createAnimation(from: atlas, animationName: "PlayerJump", timePerFrame: STANDARD_TIME_PER_FRAME)
        landAnimation = SKNode.createAnimation(from: atlas, animationName: "PlayerLand", timePerFrame: STANDARD_TIME_PER_FRAME)
        jumpShootAnimation = SKNode.createAnimation(from: atlas, animationName: "PlayerJumpShoot", timePerFrame: STANDARD_TIME_PER_FRAME)
        runShootAnimation = SKNode.createAnimation(from: atlas, animationName: "PlayerRunShoot", timePerFrame: STANDARD_TIME_PER_FRAME)
        dyingAnimation = SKNode.createAnimation(from: atlas, animationName: "PlayerDead", timePerFrame: STANDARD_TIME_PER_FRAME)
    }
    
    override func updateAnimation(){
        super.updateAnimation()
        if(currentAction == .Moving){
            run(SKAction.repeatForever(runAnimation), withKey: "Animation")
        }
            
        else if(currentAction == .Jumping){
            texture = SKTexture(imageNamed: "PlayerJump_4.png")
            if lastAction != .JumpShooting{
                run(jumpAnimation, withKey: "Animation")
            }
        }
            
        else if(currentAction == .Landing){
            let completionAction = SKAction.customAction(withDuration: 0){_,_ in self.currentAction = .Moving}
            let sequence = SKAction.sequence([landAnimation, completionAction])
            run(sequence, withKey: "Animation")
            texture = SKTexture(imageNamed: "PlayerRun_1.png")
        }
            
        else if(currentAction == .JumpShooting){
            let completionAction = SKAction.customAction(withDuration: 0){_,_ in self.currentAction = .Jumping}
            let sequence = SKAction.sequence([jumpShootAnimation, completionAction])
            run(sequence, withKey: "Animation")
        }
        
        else if(currentAction == .MovingShoot){
            let completionAction = SKAction.customAction(withDuration: 0){_,_ in self.currentAction = .Moving}
            let sequence = SKAction.sequence([runShootAnimation, completionAction])
            run(sequence, withKey: "Animation")
        }
        else if(currentAction == .Dying){
            texture = SKTexture(imageNamed: "PlayerDead_10.png")
            run(dyingAnimation, withKey: "Animation")
        }
    }
    
    //MARK: - World Interactions
    
    override func hitSolidGround(at position: CGPoint){
        super.hitSolidGround(at: position)
        guard !isDead else {return}
        if(currentAction == .Jumping || currentAction == .JumpShooting){
            currentAction = .Landing
        }
    }
    
    //MARK: - Actions
    
    func jump(){
        guard(canJump) else {return}
        velocity.y += PLAYER_JUMP_SPEED
        currentAction = .Jumping
    }
    
    func fire() -> PlayerBulletNode?{
        guard (canShoot) else {return nil}
        let bullet = PlayerBulletNode.dequeReusableNode()
        bullet.position =  self.position + CGPoint(x: (PLAYER_BULLET_START_POSITION.x) * frame.width, y: PLAYER_BULLET_START_POSITION.y * frame.height)
        
        if(currentAction == .Jumping){
            currentAction = .JumpShooting
        }
        else if(currentAction == .Moving){
            currentAction = .MovingShoot
        }
        addMuzzle()
        return bullet
    }
    
    func addMuzzle(){
        let muzzleNode = MuzzleNode.dequeReusableNode()
        muzzleNode.position = CGPoint(x:size.width*PLAYER_MUZZLE_POSITION.x , y:PLAYER_MUZZLE_POSITION.y*size.height)
        self.addChild(muzzleNode)
    }
    
    //MARK: - Damaged/ Killed
    
    override func killedAnimated(forceDirection: CGPoint) {
        currentAction = .Dying
    }
}
