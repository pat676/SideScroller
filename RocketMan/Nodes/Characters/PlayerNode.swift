//
//  Player.swift
//  RocketMan
//
//  Created by Patrick Henriksen on 14.03.2018.
//  Copyright © 2018 Patrick Henriksen. All rights reserved.
//

import SpriteKit

enum Action: Int{
    case Idle = 0, Running, Jumping, Landing, RunShooting, JumpShooting
}

class PlayerNode: PhysicsNode{
    
    //MARK: - Properties
    
    var currentAction:Action = .Idle{
        didSet (oldValue){
            lastAction = oldValue
            updateAnimation()
        }
    }
    var lastAction:Action = .Idle
    
    var canShoot: Bool{
        get{
            return currentAction == .Jumping || currentAction == .Running
        }
    }
    
    var canJump: Bool{
        get{
            return currentAction != .Jumping && currentAction != .JumpShooting && currentAction != .Landing
        }
    }
    
    var originalSize: CGSize!
    
    //MARK: - Animation Frames
    
    var runAnimation: SKAction!
    var jumpAnimation: SKAction!
    var landAnimation: SKAction!
    var jumpShootAnimation: SKAction!
    var runShootAnimation: SKAction!
    var muzzleAnimation: SKAction!
    
    //MARK: - System
    
    convenience init(playableRect: CGRect, playerMargin: CGFloat){
        self.init(imageNamed: "playerIdle")
        originalSize = size
        scale(to: PLAYER_SIZE)
        
        isAffectedByGravity = true
        physicsFrameScale = PLAYER_PHYSICS_FRAME_SCALE
        
        anchorPoint = CGPoint.zero
        position = CGPoint(x: playerMargin, y:playableRect.minY + TILE_SIZE + 500)
        
        addAnimations()
        currentAction = .Running
        updateAnimation()
    }
    
    //MARK: - Update
    
    func update(in cameraPlayableRect: CGRect){
        drawFrame()
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
        runAnimation = createAnimation(from: "Run", timePerFrame: STANDARD_TIME_PER_FRAME)
        jumpAnimation = createAnimation(from: "Jump", timePerFrame: STANDARD_TIME_PER_FRAME)
        landAnimation = createAnimation(from: "Land", timePerFrame: STANDARD_TIME_PER_FRAME)
        jumpShootAnimation = createAnimation(from: "JumpShoot", timePerFrame: STANDARD_TIME_PER_FRAME)
        runShootAnimation = createAnimation(from: "RunShoot", timePerFrame: STANDARD_TIME_PER_FRAME)
        muzzleAnimation = createAnimation(from: "Muzzle", timePerFrame: STANDARD_TIME_PER_FRAME)
    }
    
    func updateAnimation(){
        removeAllActions()
        
        if(currentAction == .Running){
            run(SKAction.repeatForever(runAnimation), withKey: "ActionAnimation")
        }
            
        else if(currentAction == .Jumping){
            texture = SKTexture(imageNamed: "playerInAir")
            if lastAction != .JumpShooting{
                run(jumpAnimation, withKey: "ActionAnimation")
            }
        }
            
        else if(currentAction == .Landing){
            let completionAction = SKAction.customAction(withDuration: 0){_,_ in self.currentAction = .Running}
            let sequence = SKAction.sequence([landAnimation, completionAction])
            run(sequence, withKey: "ActionAnimation")
            texture = SKTexture(imageNamed: "playerIdle")
        }
            
        else if(currentAction == .JumpShooting){
            let completionAction = SKAction.customAction(withDuration: 0){_,_ in self.currentAction = .Jumping}
            let sequence = SKAction.sequence([jumpShootAnimation, completionAction])
            run(sequence, withKey: "ActionAnimation")
        }
        
        else if(currentAction == .RunShooting){
            let completionAction = SKAction.customAction(withDuration: 0){_,_ in self.currentAction = .Running}
            let sequence = SKAction.sequence([runShootAnimation, completionAction])
            run(sequence, withKey: "ActionAnimation")
        }
    }
    
    //MARK: - World Interactions
    
    override func hitSolidYDirection() {
        super.hitSolidYDirection()
        if(currentAction == .Jumping || currentAction == .JumpShooting){
            currentAction = .Landing
        }
        velocity.y = 0
    }
    
    override func hitSolidXDirection(){
        super.hitSolidXDirection()
        velocity.x = 0
    }
    
    //MARK: - Actions
    
    func jump(){
        guard(isOnSolidGround && currentAction != .Jumping) else {return}
        velocity.y += PLAYER_JUMP_SPEED
        currentAction = .Jumping
    }
    
    func fire() -> PlayerBulletNode?{
        guard (canShoot) else {return nil}
        let bullet = PlayerBulletNode(position: self.position + CGPoint(x: (PLAYER_BULLET_START_POSITION.x) * frame.width, y: PLAYER_BULLET_START_POSITION.y * frame.height))
        if(currentAction == .Jumping){
            currentAction = .JumpShooting
        }
        else if(currentAction == .Running){
            currentAction = .RunShooting
        }
        addMuzzle()
        return bullet
    }
    
    func addMuzzle(){
        
        let muzzleNode = SKSpriteNode(imageNamed: "PlayerMuzzle")
        self.addChild(muzzleNode)
        
        muzzleNode.position = CGPoint(x:originalSize.width*PLAYER_MUZZLE_POSITION.x , y:PLAYER_MUZZLE_POSITION.y*originalSize.height)
        let completion = SKAction.customAction(withDuration: 0){_,_ in muzzleNode.removeFromParent()}
        let sequence = SKAction.sequence([muzzleAnimation, completion])
        muzzleNode.run(sequence)
    }

    //MARK: - Util
    
    //Returns the center position of the frame
    func centerPosition() -> CGPoint{
        return CGPoint(x:position.x + frame.width/2, y: position.y + frame.height/2)
    }
}
