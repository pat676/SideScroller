//
//  Living.swift
//  RocketMan
//
//  Created by Patrick Henriksen on 27.03.2018.
//  Copyright © 2018 Patrick Henriksen. All rights reserved.
//

import SpriteKit

enum Action: Int{
    case Idle = 0, Moving, Jumping, Landing, MovingShoot, JumpShooting, Dying, CloseAttack
}

class Living: PhysicsNode{
    
    //MARK: - Properties
    
    var lastAction:Action = .Idle
    var currentAction:Action = .Idle{
        didSet(oldValue){
            lastAction = oldValue
            if(currentAction != lastAction){
                updateAnimation()
            }
        }
    }
    
    var health: CGFloat = 1;
    var isDead:Bool{
        get{
            return health <= 0
        }
    }
    var pushbackResistance: CGFloat = 1;
    
    //MARK: - System
    
    convenience init(imageNamed: String){
        let texture = SKTexture(imageNamed: imageNamed)
        self.init(with: texture)
    }
    
    convenience init(with texture: SKTexture){
        self.init(texture: texture, color: .clear, size: texture.size())
        
        isAffectedByGravity = true
        isAffectedByPhysicNodes = true
        isAffectedByWorldSolids = true
        
        anchorPoint = CGPoint.zero
        
        addAnimations()
        updateAnimation()
    }
    
    var shouldUpdateFacing = true //Updates the facing according to movement
    var invertedFacing = false //The standard facing is to the right, this variable will invert facing
    override var velocity: CGPoint{
        willSet(newValue){
            if(shouldUpdateFacing){
                if(newValue.x < 0 && shouldUpdateFacing){
                   flipLeft()
                }
                else if(newValue.x > 0 && shouldUpdateFacing){
                    flipRight()
                }
            }
        }
    }
    
    //Mark: - Flip Node
    
    func flipLeft(){
        if(!invertedFacing && xScale < 0 || invertedFacing && xScale > 0){
            //Is allready facing left...
            return
        }
        else{
            xScale = -xScale
            position.x = position.x + size.width
        }
    }
    
    func flipRight(){
        if(!invertedFacing && xScale > 0 || invertedFacing && xScale < 0){
            //Is allready facing Right...
            return
        }
        else{
            xScale = -xScale
            position.x = position.x - size.width
        }
    }
    
    //MARK: - Animations
    
    //Should be overriden in subclasses, called when currentAction changes
    func addAnimations(){}
    func updateAnimation(){
        removeAction(forKey: "Animation")
    }
    
    //MARK: - Damage and Death
    
    func applyDamage(_ damage: CGFloat, pushback: CGFloat, forceDirection: CGPoint){
        guard health > 0 else {return}
        
        health -= damage
        if(health <= 0){
            killed(with: pushback, forceDirection: forceDirection)
        }
    }
    
    func killed(with pushback: CGFloat, forceDirection: CGPoint){
        velocity = CGPoint.zero
        if(pushback == 0){
            killedAnimated(forceDirection: forceDirection)
        }
        else{
            killedPushback(with: pushback, forceDirection: forceDirection)
        }
    }
    
    //Should be overriden in subclass to add death animation
    func killedAnimated(forceDirection: CGPoint){
        super.removeFromParent()
    }
    
    func killedPushback(with pushback: CGFloat, forceDirection: CGPoint){

        let tempTexture = self.texture
        currentAction = .Dying
        removeAction(forKey: "Animation")
        self.texture = tempTexture
    
        isAffectedByWorldSolids = false
        shouldUpdateFacing = false
        
        velocity.x = (LIVING_STANDARD_DEATH_PUSHBACK.x * forceDirection.x * pushback) / pushbackResistance
        velocity.y = (LIVING_STANDARD_DEATH_PUSHBACK.y * pushback) / pushbackResistance
        
        //Change anchor point so rotation will be around mid
        
        position.x += size.width/2*xScale
        position.y += size.height/2*yScale
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        //Start rotating
        continuesRotationAngle = LIVING_STANDARD_DEATH_ROTATION_ANGLE * xScale
        continuesRotationTime = LIVING_DEATH_ROTATION_TIME
    }
}
