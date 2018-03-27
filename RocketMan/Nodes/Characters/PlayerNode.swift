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
    
    var canShoot: Bool{ get{ return currentAction == .Jumping || currentAction == .Moving} }
    var canJump: Bool{ get{ return isOnSolidGround && (currentAction != .Jumping && currentAction != .JumpShooting)} }
    
    var originalSize: CGSize!
    
    //MARK: - Animation Actions
    
    var runAnimation: SKAction!
    var jumpAnimation: SKAction!
    var landAnimation: SKAction!
    var jumpShootAnimation: SKAction!
    var runShootAnimation: SKAction!
    
    //MARK: - System
    
    convenience init(playableRect: CGRect, playerMargin: CGFloat){
        self.init(imageNamed: "playerIdle")
        originalSize = size
        scale(to: PLAYER_SIZE)
        
        physicsFrameScale = PLAYER_PHYSICS_FRAME_SCALE
        position = CGPoint(x: playerMargin, y:playableRect.minY + TILE_SIZE + 500)
        
        addAnimations()
        currentAction = .Moving
        updateAnimation()
    }
    
    //MARK: - Update
    
    func update(in cameraPlayableRect: CGRect){
        updatePlayerVelocity(in: cameraPlayableRect)
        if(!isOnSolidGround && currentAction != .Jumping && currentAction != .JumpShooting){
            //Fallen of a platform
            currentAction = .Jumping
        }
    }
    
    // Adjusts the velocity of the player. If the player is to far left/right the speed is increased/decreased
    func updatePlayerVelocity(in cameraPlayableRect: CGRect){
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
    
    func addAnimations(){
        runAnimation = SKNode.createAnimation(from: "PlayerRun", timePerFrame: STANDARD_TIME_PER_FRAME)
        jumpAnimation = SKNode.createAnimation(from: "PlayerJump", timePerFrame: STANDARD_TIME_PER_FRAME)
        landAnimation = SKNode.createAnimation(from: "PlayerLand", timePerFrame: STANDARD_TIME_PER_FRAME)
        jumpShootAnimation = SKNode.createAnimation(from: "PlayerJumpShoot", timePerFrame: STANDARD_TIME_PER_FRAME)
        runShootAnimation = SKNode.createAnimation(from: "PlayerRunShoot", timePerFrame: STANDARD_TIME_PER_FRAME)
    }
    
    override func updateAnimation(){
        removeAllActions()
        
        if(currentAction == .Moving){
            run(SKAction.repeatForever(runAnimation), withKey: "ActionAnimation")
        }
            
        else if(currentAction == .Jumping){
            texture = SKTexture(imageNamed: "playerInAir")
            if lastAction != .JumpShooting{
                run(jumpAnimation, withKey: "ActionAnimation")
            }
        }
            
        else if(currentAction == .Landing){
            let completionAction = SKAction.customAction(withDuration: 0){_,_ in self.currentAction = .Moving}
            let sequence = SKAction.sequence([landAnimation, completionAction])
            run(sequence, withKey: "ActionAnimation")
            texture = SKTexture(imageNamed: "playerIdle")
        }
            
        else if(currentAction == .JumpShooting){
            let completionAction = SKAction.customAction(withDuration: 0){_,_ in self.currentAction = .Jumping}
            let sequence = SKAction.sequence([jumpShootAnimation, completionAction])
            run(sequence, withKey: "ActionAnimation")
        }
        
        else if(currentAction == .MovingShoot){
            let completionAction = SKAction.customAction(withDuration: 0){_,_ in self.currentAction = .Moving}
            let sequence = SKAction.sequence([runShootAnimation, completionAction])
            run(sequence, withKey: "ActionAnimation")
        }
    }
    
    //MARK: - World Interactions
    
    override func hitSolidGround(at position: CGPoint){
        super.hitSolidGround(at: position)
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
        muzzleNode.position = CGPoint(x:originalSize.width*PLAYER_MUZZLE_POSITION.x , y:PLAYER_MUZZLE_POSITION.y*originalSize.height)
        self.addChild(muzzleNode)
    }
}
