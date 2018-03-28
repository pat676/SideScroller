//
//  Living.swift
//  RocketMan
//
//  Created by Patrick Henriksen on 27.03.2018.
//  Copyright © 2018 Patrick Henriksen. All rights reserved.
//

import SpriteKit

enum Action: Int{
    case Idle = 0, Moving, Jumping, Landing, MovingShoot, JumpShooting
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
    
    //MARK: - System
    
    convenience init(imageNamed: String){
        let texture = SKTexture(imageNamed: imageNamed)
        self.init(texture: texture, color: .clear, size: texture.size())
        
        isAffectedByGravity = true
        canCollideWithPhysicNodes = true
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
    func updateAnimation(){}
}
